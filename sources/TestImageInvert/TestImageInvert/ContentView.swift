//
//  ContentView.swift
//  TestImageInvert
//
//  Created by beforeold on 7/10/24.
//

import SwiftUI

struct ContentView: View {
  @State private var resultImage: UIImage?

  var body: some View {
    VStack {
      Image(uiImage: UIImage(named: "2048")!)
        .resizable()
        .scaledToFit()

      if let resultImage {
        Image(uiImage: resultImage)
          .resizable()
          .scaledToFit()
      } else {
        Text("nothing")
      }
    }
    .onAppear {
      // Usage example
      let beginDate = Date()
      if let image = UIImage(named: "2048") {
          let invertedImage = invertImageTextColors(image: image)
          // Display the invertedImage in an image view or use it as needed
        resultImage = invertedImage
      } else {
        print("Failed to load image")
      }

      print("time", -beginDate.timeIntervalSinceNow)

    }
  }
}

#Preview {
  ContentView()
}

import UIKit
import CoreImage
//
//func invertImageTextColors(image: UIImage) -> UIImage? {
//    guard let cgImage = image.cgImage else { return nil }
//
//    // Create a CIImage from the CGImage
//    let ciImage = CIImage(cgImage: cgImage)
//
//    // Create a color invert filter
//    let invertFilter = CIFilter(name: "CIColorInvert")!
//    invertFilter.setValue(ciImage, forKey: kCIInputImageKey)
//
//    // Apply the invert filter to get the inverted image
//    guard let invertedImage = invertFilter.outputImage else { return nil }
//
//    // Create a threshold filter to isolate the white text areas
//    let thresholdFilter = CIFilter(name: "CIColorClamp")!
//    thresholdFilter.setValue(invertedImage, forKey: kCIInputImageKey)
//    thresholdFilter.setValue(CIVector(x: 0.5, y: 0.5, z: 0.5, w: 1.0), forKey: "inputMinComponents")
//    thresholdFilter.setValue(CIVector(x: 1.0, y: 1.0, z: 1.0, w: 1.0), forKey: "inputMaxComponents")
//
//    guard let thresholdedImage = thresholdFilter.outputImage else { return nil }
//
//    // Combine the original image with the thresholded image
//    let blendFilter = CIFilter(name: "CIBlendWithAlphaMask")!
//    blendFilter.setValue(thresholdedImage, forKey: kCIInputMaskImageKey)
//    blendFilter.setValue(ciImage, forKey: kCIInputBackgroundImageKey)
//    blendFilter.setValue(invertedImage, forKey: kCIInputImageKey)
//
//    guard let outputImage = blendFilter.outputImage else { return nil }
//
//    // Create a context and convert the output CIImage to a CGImage
//    let context = CIContext()
//    guard let cgOutputImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
//
//    // Create and return a UIImage from the CGImage
//    return UIImage(cgImage: cgOutputImage)
//}

import UIKit
import CoreImage
//
//func invertImageTextColors(image: UIImage) -> UIImage? {
//    guard let cgImage = image.cgImage else { return nil }
//
//    // Create a CIImage from the CGImage
//    let ciImage = CIImage(cgImage: cgImage)
//
//    // Create a grayscale version of the image to use as a mask
//    let grayscaleFilter = CIFilter(name: "CIPhotoEffectMono")!
//    grayscaleFilter.setValue(ciImage, forKey: kCIInputImageKey)
//    guard let grayscaleImage = grayscaleFilter.outputImage else { return nil }
//
//    // Create a color invert filter
//    let invertFilter = CIFilter(name: "CIColorInvert")!
//    invertFilter.setValue(ciImage, forKey: kCIInputImageKey)
//
//    // Apply the invert filter to get the inverted image
//    guard let invertedImage = invertFilter.outputImage else { return nil }
//
//    // Create a threshold filter to isolate the white areas (text)
//    let thresholdFilter = CIFilter(name: "CIColorClamp")!
//    thresholdFilter.setValue(grayscaleImage, forKey: kCIInputImageKey)
//    thresholdFilter.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 1.0), forKey: "inputMinComponents")
//    thresholdFilter.setValue(CIVector(x: 1.0, y: 1.0, z: 1.0, w: 1.0), forKey: "inputMaxComponents")
//
//    guard let thresholdedImage = thresholdFilter.outputImage else { return nil }
//
//    // Blend the original image with the inverted image using the thresholded image as mask
//    let blendFilter = CIFilter(name: "CIBlendWithMask")!
//    blendFilter.setValue(invertedImage, forKey: kCIInputImageKey)
//    blendFilter.setValue(ciImage, forKey: kCIInputBackgroundImageKey)
//    blendFilter.setValue(thresholdedImage, forKey: kCIInputMaskImageKey)
//
//    guard let outputImage = blendFilter.outputImage else { return nil }
//
//    // Create a context and convert the output CIImage to a CGImage
//    let context = CIContext()
//    guard let cgOutputImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
//
//    // Create and return a UIImage from the CGImage
//    return UIImage(cgImage: cgOutputImage)
//}

import UIKit
import CoreImage

func invertImageTextColors(image: UIImage) -> UIImage? {
    guard let cgImage = image.cgImage else { return nil }

    // Create a CIImage from the CGImage
    let ciImage = CIImage(cgImage: cgImage)

    // Create a grayscale version of the image to use as a mask
    let grayscaleFilter = CIFilter(name: "CIPhotoEffectMono")!
    grayscaleFilter.setValue(ciImage, forKey: kCIInputImageKey)
    guard let grayscaleImage = grayscaleFilter.outputImage else { return nil }

    // Create a color invert filter
    let invertFilter = CIFilter(name: "CIColorInvert")!
    invertFilter.setValue(ciImage, forKey: kCIInputImageKey)

    // Apply the invert filter to get the inverted image
    guard let invertedImage = invertFilter.outputImage else { return nil }

    // Create a threshold filter to isolate the white areas (text)
    let thresholdFilter = CIFilter(name: "CIColorClamp")!
    thresholdFilter.setValue(grayscaleImage, forKey: kCIInputImageKey)
    thresholdFilter.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 1.0), forKey: "inputMinComponents")
    thresholdFilter.setValue(CIVector(x: 1.0, y: 1.0, z: 1.0, w: 1.0), forKey: "inputMaxComponents")

    guard let thresholdedImage = thresholdFilter.outputImage else { return nil }

    // Blend the original image with the inverted image using the thresholded image as mask
    let blendFilter = CIFilter(name: "CIBlendWithMask")!
    blendFilter.setValue(invertedImage, forKey: kCIInputImageKey)
    blendFilter.setValue(ciImage, forKey: kCIInputBackgroundImageKey)
    blendFilter.setValue(thresholdedImage, forKey: kCIInputMaskImageKey)

    guard let outputImage = blendFilter.outputImage else { return nil }

    // Create a context and convert the output CIImage to a CGImage
    let context = CIContext()
    guard let cgOutputImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }

    // Create and return a UIImage from the CGImage
    return UIImage(cgImage: cgOutputImage)
}

