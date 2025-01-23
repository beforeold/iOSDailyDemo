// The Swift Programming Language
// https://docs.swift.org/swift-book

import SensorsAnalyticsSDK
import UIKit

func foo() {
  SensorsAnalyticsSDK.start(
    configOptions: .init(
      serverURL: "",
      launchOptions: nil
    )
  )
}
