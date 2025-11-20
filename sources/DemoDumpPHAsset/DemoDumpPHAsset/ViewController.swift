import UIKit
import Photos
import ObjectiveC.runtime

class ViewController: UIViewController {

  private let photoAssetDumper = PhotoAssetDumper()

  override func viewDidLoad() {
    super.viewDidLoad()
    photoAssetDumper.runDemo()
  }
}

final class PhotoAssetDumper {

  func runDemo() {
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
      guard status == .authorized || status == .limited else {
        print("Photo library access denied: \(status.rawValue)")
        return
      }
      guard let asset = self?.fetchMostRecentAsset() else {
        print("No PHAsset found to inspect.")
        return
      }
      self?.logAssetBasics(asset)
      self?.dumpIvars(of: asset)
    }
  }

  private func fetchMostRecentAsset() -> PHAsset? {
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    return result.firstObject
  }

  private func logAssetBasics(_ asset: PHAsset) {
    print("----- PHAsset Demo -----")
    print("localIdentifier: \(asset.localIdentifier)")
    if let creationDate = asset.creationDate {
      print("creationDate: \(creationDate)")
    }
    print("pixelWidth x pixelHeight: \(asset.pixelWidth) x \(asset.pixelHeight)")
    print("mediaType: \(asset.mediaType.rawValue)")
    print("------------------------")
  }

  private func dumpIvars(of asset: PHAsset) {
    var count: UInt32 = 0
    guard let ivars = class_copyIvarList(PHAsset.self, &count) else {
      print("Unable to copy ivar list.")
      return
    }
    defer { free(ivars) }

    for index in 0..<Int(count) {
      let ivar = ivars[index]
      let name = ivar_getName(ivar).flatMap { String(cString: $0) } ?? "<unknown>"
      let encoding = ivar_getTypeEncoding(ivar).flatMap { String(cString: $0) } ?? "?"
      let valueDescription = describeValue(of: asset, ivar: ivar, encoding: encoding)
      print("\(name) [\(encoding)]: \(valueDescription)")
    }
  }

  private func describeValue(of asset: PHAsset, ivar: Ivar, encoding: String) -> String {
    if encoding.hasPrefix("@") {
      if let value = object_getIvar(asset, ivar) {
        return "\(value)"
      } else {
        return "nil"
      }
    }

    let basePointer = Unmanaged.passUnretained(asset).toOpaque()
    let offset = Int(ivar_getOffset(ivar))
    let rawPointer = basePointer.advanced(by: offset)

    switch encoding {
    case "q":
      return "\(rawPointer.assumingMemoryBound(to: Int64.self).pointee)"
    case "Q":
      return "\(rawPointer.assumingMemoryBound(to: UInt64.self).pointee)"
    case "i":
      return "\(rawPointer.assumingMemoryBound(to: Int32.self).pointee)"
    case "I":
      return "\(rawPointer.assumingMemoryBound(to: UInt32.self).pointee)"
    case "s":
      return "\(rawPointer.assumingMemoryBound(to: Int16.self).pointee)"
    case "S":
      return "\(rawPointer.assumingMemoryBound(to: UInt16.self).pointee)"
    case "c":
      return "\(rawPointer.assumingMemoryBound(to: Int8.self).pointee)"
    case "C":
      return "\(rawPointer.assumingMemoryBound(to: UInt8.self).pointee)"
    case "f":
      return "\(rawPointer.assumingMemoryBound(to: Float.self).pointee)"
    case "d":
      return "\(rawPointer.assumingMemoryBound(to: Double.self).pointee)"
    case "B":
      return "\(rawPointer.assumingMemoryBound(to: Bool.self).pointee)"
    default:
      return "<unsupported type \(encoding)>"
    }
  }
}
