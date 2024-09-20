@_exported import UIKit

// workaround for xcode preview
import Foundation
extension Foundation.Bundle {
  private class BundleFinder { }

  static var current: Bundle = {
    /* The name of your local package, prepended by "LocalPackages_" */
    let bundleName = "BizTemplate_BizTemplate"

    // return Bundle.currentBundle(for: BundleFinder.self, bundleName: bundleName)
    return .main
  }()
}
