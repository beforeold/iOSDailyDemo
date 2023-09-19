//
//  ImageChecker.swift
//  AIGC
//
//  Created by Hank Zhang on 2023/8/28.
//

import Foundation
import UIKit
import Vision

struct ImageChecker {

  static func checkOriginal(_ image: UIImage) throws -> Result {
#if targetEnvironment(simulator)
    return .success
#else
    let models = [ImageProcessModel(index: 0, image: image)]
    try checkFaces(models)
    guard let result = models.map({ $0.result }).first else { throw Error.detector }
    return result
#endif
  }

  static func check(_ originalImage: UIImage, images: [UIImage] = []) throws -> [Result] {
#if targetEnvironment(simulator)
    return images.map { _ in .success }
#else
    let models = images.enumerated().map { ImageProcessModel(index: $0.offset, image: $0.element) }
    try checkFaces(models)
    try checkSimilarity(models.filter { $0.result == .success })
    return models.map { $0.result }
#endif
  }

}

// MARK: - Type declaration
extension ImageChecker {

  enum Result {
    case success, noFace, multiFaces, lowQuality, simularPhotos, notFront
  }

  enum Error: Swift.Error {
    case format, detector
  }

  private class ImageProcessModel {
    let index: Int
    let image: UIImage
    var result: Result
    var feature: VNFeaturePrintObservation?

    init(index: Int, image: UIImage, result: Result = .success) {
      self.index = index
      self.image = image
      self.result = result
    }
  }

}

// MARK: - Helpers
extension ImageChecker {

  private static func checkFaces(_ models: [ImageProcessModel]) throws {
    for model in models {
      guard let cgImage = model.image.cgImage else { throw Error.format }

      // Detect faces and quality
      let qualityRequest = VNDetectFaceCaptureQualityRequest()
      let rectanglesRequest = VNDetectFaceRectanglesRequest()
      let handler = VNImageRequestHandler(cgImage: cgImage)
      do { try handler.perform([qualityRequest, rectanglesRequest]) } catch { throw Error.detector }

      // Image has not face
      guard let observations = qualityRequest.results, !observations.isEmpty else {
        model.result = .noFace
        continue
      }

      if let rectangles = rectanglesRequest.results?.first,
            let roll = rectangles.roll?.doubleValue,
            let yaw = rectangles.yaw?.doubleValue,
            let pitch = rectangles.pitch?.doubleValue {
        print(#function,
              "roll: \(String(format: "%.2f", roll))",
              "yaw: \(String(format: "%.2f", yaw))",
              "pitch: \(String(format: "%.2f", pitch))")
      }

      // Image has a low quality face
      guard let quality = qualityRequest.results?.first?.faceCaptureQuality else { throw Error.detector }
      print(#function, "quality", quality)

      // Image has multiple faces
      if observations.count > 1 {
        model.result = .multiFaces
        continue
      }

      if Double(quality) < thresholdFaceQuality {
        model.result = .lowQuality
        continue
      }

      // Image has a not front face
      guard let rectangles = rectanglesRequest.results?.first,
            let roll = rectangles.roll?.doubleValue,
            let yaw = rectangles.yaw?.doubleValue,
            let pitch = rectangles.pitch?.doubleValue else { throw Error.detector }
      // print(#function, "roll: \(roll)", "yaw: \(yaw)", "pitch: \(pitch)")
      
      if abs(roll) > thresholdRoll
          || abs(yaw) > thresholdYaw
          || abs(pitch) > thresholdPitch {
        model.result = .notFront
        continue
      }

      model.result = .success
    }
  }

  private static func checkSimilarity(_ models: [ImageProcessModel]) throws {
    guard models.count > 1 else { return }

    // Extract image features
    for model in models {
      guard let cgImage = model.image.cgImage else { throw Error.format }
      let handler = VNImageRequestHandler(cgImage: cgImage)
      let request = VNGenerateImageFeaturePrintRequest()
      try handler.perform([request])
      guard let feature = request.results?.first else { throw Error.detector }
      model.feature = feature
    }

    // Compare each image to previous images
    models[0].result = .success
    var first = 1
    while first < models.count {
      var simular = false
      guard let featureI = models[first].feature else { continue }
      for second in 0..<first {
        var distance = Float(0)
        guard let featureJ = models[second].feature else { continue }
        try featureI.computeDistance(&distance, to: featureJ)
        if Double(distance) < thresholdSimilarity {
          simular = true
          break
        }
      }
      models[first].result = simular ? .simularPhotos : .success
      first += 1
    }
  }
}

extension ImageChecker {
  static var thresholdSimilarity: Double = 0.5

  static var thresholdFaceQuality: Double = 0.5

  static var thresholdRoll: Double = 0.5

  static var thresholdYaw: Double = 0.5

  static var thresholdPitch: Double = 0.5
}

// MARK: - Result
extension ImageChecker.Result {

  var code: Int {
    switch self {
    case .success:
      return 0
    case .simularPhotos:
      return 1
    case .noFace:
      return 2
    case .lowQuality:
      return 3
    case .multiFaces:
      return 4
    case .notFront:
      return 5
    }
  }
}
