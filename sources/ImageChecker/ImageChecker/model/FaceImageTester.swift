//
//  FaceImageTester.swift
//  ImageChecker
//
//  Created by Brook_Mobius on 9/15/23.
//

import SwiftUI
import Kingfisher

@MainActor class FaceImageTester: ObservableObject {
  @Published var countFlags: [String: Int] = [:] {
    didSet {
      let flags = self.countFlags
      DispatchQueue.global().async {
        @UserStorage("FaceImageTester_v1_count")
        var value: [String: Int] = [:]
        value = flags
      }
    }
  }

  @Published var frontFlags: [String: Bool] = [:] {
    didSet {
      let flags = self.frontFlags
      DispatchQueue.global().async {
        @UserStorage("FaceImageTester_v1_front")
        var value: [String: Bool] = [:]
        value = flags
      }
    }
  }

  @Published var qualityFlags: [String: Bool] = [:] {
    didSet {
      let flags = self.qualityFlags
      DispatchQueue.global().async {
        @UserStorage("FaceImageTester_v1_quality")
        var value: [String: Bool] = [:]
        value = flags
      }
    }
  }

  func updateFront(flag: Bool?, url: String) {
    frontFlags[url] = flag
  }

  func updateCount(flag: Int?, url: String) {
    countFlags[url] = flag
  }

  func updateQuality(flag: Bool?, url: String) {
    qualityFlags[url] = flag
  }

  @Published var checkResult: ImageChecker.Result? = nil

  @Published var selectedInfo: SelectedInfo?

  @UserStorage("FaceImageTester_v1_selected")
  private var selected: SelectedInfo? = nil {
    didSet {
      selectedInfo = selected

      checkSelected()
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
    KingfisherManager.shared.cache.diskStorage.config.sizeLimit = 0

    do {
      @UserStorage("FaceImageTester_v1_count")
      var flags: [String: Int] = [:]
      self.countFlags = flags
    }

    do {
      @UserStorage("FaceImageTester_v1_front")
      var flags: [String: Bool] = [:]
      self.frontFlags = flags
    }

    do {
      @UserStorage("FaceImageTester_v1_quality")
      var flags: [String: Bool] = [:]
      self.qualityFlags = flags
    }

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

  func showInfo() {
    showLabelCount()
  }

  func showLabelCount() {
    let oneFaces = items.filter { item in
      countFlags[item.url] == 1
    }
    print("oneFace", oneFaces.count)

    let frontFaces = items.filter { item in
      countFlags[item.url] == 1 && frontFlags[item.url] == true
    }
    print("frontFaces", frontFaces.count)

    let notFrontFaces = items.filter { item in
      countFlags[item.url] == 1 && frontFlags[item.url] == false
    }
    print("notFrontFaces", notFrontFaces.count)


    let qualityFaces = items.filter { item in
      countFlags[item.url] == 1 && qualityFlags[item.url] == true
    }
    print("qualityFaces", qualityFaces.count)

    let lowQualityFrontFaces = items.filter { item in
      countFlags[item.url] == 1 && qualityFlags[item.url] == false
    }
    print("lowQualityFrontFaces", lowQualityFrontFaces.count)
  }

  /// 打印打标的结果信息
  private func logLabelResult() {
    items.forEach { item in
      print(item.url)
    }

    print("===== frontFlags")

    items.forEach { item in
      print((frontFlags[item.url])?.description ?? "none")
    }

    print("===== qualityFlags")

    items.forEach { item in
      print((qualityFlags[item.url])?.description ?? "none")
    }
  }

  func checkQuality() {
    ImageChecker.thresholdFaceQuality = 0.4
    ImageChecker.thresholdRoll = 10
    ImageChecker.thresholdYaw = 10
    ImageChecker.thresholdPitch = 10

    let qualityFaces = items.filter { item in
      countFlags[item.url] == 1 && qualityFlags[item.url] == true
    }
    print("qualityFaces", qualityFaces.count)

    let lowQualityFrontFaces = items.filter { item in
      countFlags[item.url] == 1 && qualityFlags[item.url] == false
    }
    print("lowQualityFrontFaces", lowQualityFrontFaces.count)

    Task {
      print("check qualityFaces")
      await FaceImageTester.check(items: qualityFaces, expecting: .success)
    }
    Task {
      print("check lowQualityFrontFaces")
      await FaceImageTester.check(items: lowQualityFrontFaces, expecting: .lowQuality)
    }
  }

  func checkFront() {
    let value = 0.55
    ImageChecker.thresholdFaceQuality = 0.0
    ImageChecker.thresholdRoll = value
    ImageChecker.thresholdYaw = value
    ImageChecker.thresholdPitch = value

    let frontFaces = items.filter { item in
      countFlags[item.url] == 1 && frontFlags[item.url] == true
    }
    print("frontFaces", frontFaces.count)

    let notFrontFaces = items.filter { item in
      countFlags[item.url] == 1 && frontFlags[item.url] == false
    }
    print("notFrontFaces", notFrontFaces.count)

    Task {
      print("check frontFaces")
      await FaceImageTester.check(items: frontFaces, expecting: .success)
    }
    Task {
      print("check notFrontFaces")
      await FaceImageTester.check(items: notFrontFaces, expecting: .notFront)
    }
  }

  static func check(items: [DataLoader.Item], expecting: ImageChecker.Result) async {
    var checkResult: (fullfil: Int, reject: Int, error: Int) = (0, 0, 0)

    for item in items {
      do {
        let image = try await ImageDownloader.load(item: item)
        let result = try ImageChecker.checkOriginal(image)
        if result == expecting {
          checkResult.fullfil += 1
        } else {
          checkResult.reject += 1
        }
      } catch {
        checkResult.error += 1
      }
    }
    print(checkResult)
  }

  private func checkSelected() {
    Task {
      do {
        guard let item = selected?.item else {
          self.checkResult = nil
          return
        }
        debugPrint()
        let image = try await ImageDownloader.load(item: item)
        let result = try ImageChecker.checkOriginal(image)
        self.checkResult = result
      } catch {
        print(error)
        self.checkResult = nil
      }
      print(resultDesc)
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
