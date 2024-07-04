//
//  HostingControllerKey.swift
//  TestSwiftUIFindController
//
//  Created by xipingping on 7/2/24.
//

import SwiftUI
import UIKit

private struct HostingControllerKey: EnvironmentKey {
  static let defaultValue: Box? = nil
}

public extension EnvironmentValues {
  var hostingController: UIViewController? {
    get { self[HostingControllerKey.self]?.controller }
    set { self[HostingControllerKey.self] = Box(controller: newValue) }
  }
}

public extension View {
  func hostingController(_ controller: UIViewController) -> some View {
    environment(\.hostingController, controller)
  }
}

private class Box {
  weak var controller: UIViewController?
  init(controller: UIViewController? = nil) {
    self.controller = controller
  }
}
