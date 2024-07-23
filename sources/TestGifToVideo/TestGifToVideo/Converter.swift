import UIKit
import AVFoundation
import ImageIO

func convertGifToVideo(gifUrl: URL, outputUrl: URL, completion: @escaping (Result<URL, Error>) -> Void) {
  // Create an AVAssetWriter to write the video file
  do {
    let assetWriter = try AVAssetWriter(outputURL: outputUrl, fileType: .mp4)

    // Set up the video settings
    let videoSettings: [String: Any] = [
      AVVideoCodecKey: AVVideoCodecType.h264,
      AVVideoWidthKey: 480,
      AVVideoHeightKey: 320
    ]

    // Create an AVAssetWriterInput
    let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
    assetWriter.add(writerInput)

    // Create an AVAssetWriterInputPixelBufferAdaptor
    let sourceBufferAttributes: [String: Any] = [
      kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
      kCVPixelBufferWidthKey as String: 480,
      kCVPixelBufferHeightKey as String: 320
    ]
    let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: sourceBufferAttributes)

    // Start writing
    assetWriter.startWriting()
    assetWriter.startSession(atSourceTime: .zero)

    // Load the GIF using CGImageSource
    guard let gifSource = CGImageSourceCreateWithURL(gifUrl as CFURL, nil) else {
      completion(.failure(NSError(domain: "GIFError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load GIF"])))
      return
    }

    let frameCount = CGImageSourceGetCount(gifSource)
    var frameDuration: TimeInterval = 0.1 // Default frame duration

    // Iterate over each frame
    for i in 0..<frameCount {
      if let cgImage = CGImageSourceCreateImageAtIndex(gifSource, i, nil) {
        // Get the frame duration
        if let properties = CGImageSourceCopyPropertiesAtIndex(gifSource, i, nil) as? [String: Any],
           let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
           let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? NSNumber {
          frameDuration = delayTime.doubleValue
        }

        // Create a pixel buffer
        var pixelBuffer: CVPixelBuffer?
        guard let pixelBufferPool = pixelBufferAdaptor.pixelBufferPool else {
          completion(.failure(NSError(domain: "PixelBufferError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create pixel buffer"])))
          return
        }
        let status = CVPixelBufferPoolCreatePixelBuffer(nil, pixelBufferPool, &pixelBuffer)
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
          completion(.failure(NSError(domain: "PixelBufferError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create pixel buffer"])))
          return
        }

        // Lock the buffer base address
        CVPixelBufferLockBaseAddress(buffer, [])
        let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                                width: Int(CVPixelBufferGetWidth(buffer)),
                                height: Int(CVPixelBufferGetHeight(buffer)),
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)

        // Draw the image into the context
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: 480, height: 320))

        // Unlock the buffer base address
        CVPixelBufferUnlockBaseAddress(buffer, [])

        // Calculate the presentation time for the frame
        let frameTime = CMTimeMakeWithSeconds(frameDuration * Double(i), preferredTimescale: 600)

        // Append the buffer to the adaptor
        pixelBufferAdaptor.append(buffer, withPresentationTime: frameTime)
      }
    }

    // Finish writing
    writerInput.markAsFinished()
    assetWriter.finishWriting {
      switch assetWriter.status {
      case .completed:
        completion(.success(outputUrl))
      case .failed:
        completion(.failure(assetWriter.error ?? NSError(domain: "WriterError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to write video"])))
      default:
        completion(.failure(NSError(domain: "WriterError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])))
      }
    }
  } catch {
    completion(.failure(error))
  }
}
