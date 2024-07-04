//
//  View+ControllerHolder.swift
//
//
//  Created by xipingping on 7/2/24.
//

import SwiftUI
import UIKit

extension View {
  /// Attaches a ControllerHolder as an environment object for the view.
  ///
  /// Example usage:
  /// ```swift
  /// let holder = ControllerHolder()
  /// let rootView = YourView().controllerHolder(holder)
  /// let hostingController = UIHostingController(rootView: rootView)
  /// super.init(nibName: nil, bundle: nil)
  /// holder.controller = self
  /// ```
  ///
  /// - Parameter holder: The ControllerHolder instance to attach.
  /// - Returns: A view with the ControllerHolder attached as an environment object.
  public func controllerHolder(_ holder: ControllerHolder) -> some View {
    self.environment(\.controllerHolder, holder)
  }
}

/// a holder for weak reference
public class ControllerHolder {
  public weak var controller: UIViewController?

  public init(controller: UIViewController? = nil) {
    self.controller = controller
  }
}

extension EnvironmentValues {
  /// get the hosting controller from the enviroment
  ///
  ///  define a property in your view
  /// ```Swift
  /// @Environment(\.hostingController) var hostingController
  /// ```
  ///
  public var hostingController: UIViewController? {
    controllerHolder?.controller
  }

  fileprivate var controllerHolder: ControllerHolder? {
    get { self[HostingControllerKey.self] }
    set { self[HostingControllerKey.self] = newValue }
  }
}

private struct HostingControllerKey: EnvironmentKey {
  static let defaultValue: ControllerHolder? = nil
}
