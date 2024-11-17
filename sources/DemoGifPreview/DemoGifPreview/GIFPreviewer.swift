import ImageIO
import SwiftUI

//
//struct GIFPreviewer: View {
//  @State private var frames: [PlatformImage] = []
//  @State private var currentFrameIndex = 0
//  @State private var playbackSpeed: Double = 1.0  // seconds per frame
//
//  let gifName = "Artguru"  // name of your GIF file (without extension)
//
//  var body: some View {
//    VStack {
//      if frames.isEmpty {
//        Text("Loading GIF...")
//          .onAppear {
//            loadGifFrames()
//          }
//      } else {
//        #if canImport(UIKit)
//          Image(uiImage: frames[currentFrameIndex])
//          .resizable()
//          .scaledToFit()
//          .frame(width: 300, height: 300)
//          .onAppear {
//            startGIFPlayback()
//          }
//        #else
//          Image(nsImage: frames[currentFrameIndex])
//          .resizable()
//          .scaledToFit()
//          .frame(width: 300, height: 300)
//          .onAppear {
//            startGIFPlayback()
//          }
//        #endif
//
//      }
//
//      Slider(value: $playbackSpeed, in: 0.1...2.0, step: 0.1) {
//        Text("Playback Speed")
//      }
//      .padding()
//      .onChange(of: playbackSpeed) { _ in
//        stopGIFPlayback()
//        startGIFPlayback()
//      }
//    }
//  }
//
//  // Loads the frames from the GIF file
//  private func loadGifFrames() {
//    guard let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif"),
//      let gifData = NSData(contentsOfFile: gifPath) as Data?
//    else {
//      print("GIF file not found.")
//      return
//    }
//    frames = extractFrames(from: gifData)
//  }
//
//  // Extract frames from GIF data
//  private func extractFrames(from gifData: Data) -> [PlatformImage] {
//    guard let source = CGImageSourceCreateWithData(gifData as CFData, nil) else { return [] }
//    var images: [PlatformImage] = []
//
//    let count = CGImageSourceGetCount(source)
//    for i in 0..<count {
//      if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
//        images.append(PlatformImage(cgImage: cgImage, size: CGSize(width: 1000, height: 1000)))
//      }
//    }
//    return images
//  }
//
//  // Timer control for GIF playback
//  private func startGIFPlayback() {
//    Timer.scheduledTimer(withTimeInterval: playbackSpeed, repeats: true) { timer in
//      currentFrameIndex = (currentFrameIndex + 1) % frames.count
//    }
//  }
//
//  private func stopGIFPlayback() {
//    currentFrameIndex = 0
//  }
//}
//
//struct GIFPreviewer_Previews: PreviewProvider {
//  static var previews: some View {
//    GIFPreviewer()
//  }
//}

let slowestValue: Double = 2

struct GIFPreviewer: View {
  @State private var frames: [PlatformImage] = []
  @State private var currentFrameIndex = 0
  @State private var playbackSpeed: Double = slowestValue / 2  // seconds per frame

  @State private var timer: Timer?

  let gifName = "Artguru"  // name of your GIF file (without extension)

  var body: some View {
    VStack {
      if frames.isEmpty {
        Text("Loading GIF...")
          .onAppear {
            loadGifFrames()
          }
      } else {
        PlatformImageView(image: frames[currentFrameIndex])
          .scaledToFit()
          .frame(width: 300, height: 300)
          .onAppear {
            startGIFPlayback()
          }
          .overlay(alignment: .top) {
            if currentFrameIndex == frames.endIndex {
              Text("last")
                .foregroundColor(.white)
                .background(Color.blue)
            }
          }


      }

      Slider(value: $playbackSpeed, in: 0.1...slowestValue, step: 0.1) {
        Text("Playback Speed")
      }
      .padding()
      .onChange(of: playbackSpeed) { _ in
        stopGIFPlayback()
        startGIFPlayback()
      }
    }
    //        .frame(idealWidth: 400, idealHeight: 400) // Adjust frame for macOS
  }

  // Loads the frames from the GIF file
  private func loadGifFrames() {
    guard let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif"),
      let gifData = NSData(contentsOfFile: gifPath) as Data?
    else {
      print("GIF file not found.")
      return
    }
    frames = extractFrames(from: gifData)
    print("frame count", frames.count)
  }

  // Extract frames from GIF data
  private func extractFrames(from gifData: Data) -> [PlatformImage] {
    guard let source = CGImageSourceCreateWithData(gifData as CFData, nil) else { return [] }
    var images: [PlatformImage] = []

    let count = CGImageSourceGetCount(source)
    for i in 0..<count {
      if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
        #if os(iOS)
          images.append(UIImage(cgImage: cgImage))
        #elseif os(macOS)
          images.append(NSImage(cgImage: cgImage, size: NSZeroSize))
        #endif
      }
    }
    return images
  }

  // Timer control for GIF playback
  private func startGIFPlayback() {
    timer = Timer.scheduledTimer(withTimeInterval: playbackSpeed, repeats: true) { timer in
      currentFrameIndex = (currentFrameIndex + 1) % frames.count
    }
  }

  private func stopGIFPlayback() {
    currentFrameIndex = 0
    timer?.invalidate()
  }
}

// Platform-specific types for image and image view
#if os(iOS)
  typealias PlatformImage = UIImage

  struct PlatformImageView: View {
    let image: UIImage

    var body: some View {
      Image(uiImage: image)
    }
  }
#elseif os(macOS)
  typealias PlatformImage = NSImage

  struct PlatformImageView: View {
    let image: NSImage

    var body: some View {
      Image(nsImage: image)
    }
  }
#endif

struct GIFPreviewer_Previews: PreviewProvider {
  static var previews: some View {
    GIFPreviewer()
  }
}
