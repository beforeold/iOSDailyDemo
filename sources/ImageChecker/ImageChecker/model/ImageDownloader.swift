//
//  ImageDownloader.swift
//  ImageChecker
//
//  Created by Brook_Mobius on 9/14/23.
//

import UIKit
import Kingfisher

actor Counter {
  var count = 0

  func plus() {
    count += 1
  }
}

struct ImageDownloader {
  static func load(item: DataLoader.Item) async throws -> UIImage {
    return try await withCheckedThrowingContinuation { continuation in
      let url = URL(string: item.url)!
      KingfisherManager.shared.retrieveImage(with: url) { result in
        do {
          let value = try result.get()
          continuation.resume(returning: value.image)
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }

  static func loadItems(
    _ items: [DataLoader.Item],
    progress: @MainActor @escaping (Int) -> Void,
    completion: @escaping () -> Void
  ) {
    debugPrint(#function, "start", items.count)

    let beginTime = Date()
    let counter = Counter()

    let group = DispatchGroup()
    let list = items.map(Box.init)

    for box in list {
      let item = box.value
      guard let url = URL(string: item.url) else {
        debugPrint(#function, "invalid url", item.url)
        continue
      }

      group.enter()
      KingfisherManager.shared.retrieveImage(with: url) { result in
        let value = try? result.get()
        box.isDone = value != nil
        Task {
          await counter.plus()
          let count = await counter.count
          await progress(count)
          print(#function, "current count", count)
        }
        group.leave()
      }
    }

    group.notify(queue: .main) {
      debugPrint(#function, "download span", -beginTime.timeIntervalSinceNow)
      completion()
    }
    
  }
}

extension ImageDownloader {
  class Box<T> {
    let value: T
    var isDone: Bool?

    init(value: T) {
      self.value = value
    }
  }
}
