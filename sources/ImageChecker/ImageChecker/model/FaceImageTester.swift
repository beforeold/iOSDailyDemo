//
//  FaceImageTester.swift
//  ImageChecker
//
//  Created by Brook_Mobius on 9/15/23.
//

import Foundation

struct FaceImageTester {
  let items: [DataLoader.Item]

  func testFace() async throws {
    for item in items {
      do {
        // let beginDate = Date()
        let image = try await ImageDownloader.load(item: item)
        // print("fetch", -beginDate.timeIntervalSinceNow)

        let result = try ImageChecker.checkOriginal(image)
        // print("check", -beginDate.timeIntervalSinceNow)

        if case .success = result {
          debugPrint(result)
        } else {
          debugPrint(result, item.url)
        }

      } catch {
        debugPrint(#function, error)
      }
    }
  }
}
