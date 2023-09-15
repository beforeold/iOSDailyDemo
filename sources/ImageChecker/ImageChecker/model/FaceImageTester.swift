//
//  FaceImageTester.swift
//  ImageChecker
//
//  Created by Brook_Mobius on 9/15/23.
//

import SwiftUI
import Kingfisher

@MainActor class FaceImageTester: ObservableObject {
  @UserStorage("FaceImageTester_v1_front")
  static var frontFlags: [String: Bool] = [:]

  @UserStorage("FaceImageTester_v1_quality")
  static var qualityFlags: [String: Bool] = [:]

  static func updateFront(flag: Bool?, url: String) {
    frontFlags[url] = flag
  }

  static func updateQuality(flag: Bool?, url: String) {
    qualityFlags[url] = flag
  }

  @Published var changed = UUID()

  @Published var checkResult: ImageChecker.Result? = nil

  @Published var selectedInfo: SelectedInfo?

  @UserStorage("FaceImageTester_v1_selected")
  private var selected: SelectedInfo? = nil {
    didSet {
      selectedInfo = selected
      Task {
        do {
          guard let item = selected?.item else {
            self.checkResult = nil
            return
          }
          let image = try await ImageDownloader.load(item: item)
          self.checkResult = try ImageChecker.checkOriginal(image)
        } catch {
          self.checkResult = nil
        }
      }
    }
  }

  var resultDesc: String {
    guard let selected else {
      return "none"
    }

    if let checkResult {
      return "\(ImageChecker.Result(selected.item.status)) (\(checkResult))"
    } else {
      return "none"
    }
  }

  var items: [DataLoader.Item] = []

  init() {
    Task {
      items = (try? await DataLoader.load()) ?? []

      if let selected {
        debugPrint(selected)
        self.selected = selected
      } else {
        self.selected = SelectedInfo(index: 0, item: items[0])
      }
    }
  }


  func handle(isForward: Bool, selected: SelectedInfo) {
    let newIndex = selected.index + (isForward ? 1 : -1)
    if newIndex < 0 || newIndex >= items.count {
      return
    }

    let item = items[newIndex]
    self.selected = SelectedInfo(index: newIndex, item: item)
  }

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


extension FaceImageTester {
  struct SelectedInfo: Codable {
    let index: Int
    let item: DataLoader.Item

    static let mock = SelectedInfo(
      index: 0,
      item: .mock
    )
  }

}

extension ImageChecker.Result {
  init(_ status: Int) {
    switch status {
    case 0: self = .success
    case 1: self = .simularPhotos
    case 2: self = .noFace
    case 3: self = .lowQuality
    case 4: self = .multiFaces

    default:
      assertionFailure()
      self = .noFace
    }
  }
}
