//
//  UIKit+Preview.swift
//  TestLottie
//
//  Created by Brook_Mobius on 7/20/23.
//

import SwiftUI

/// A type that can be used to preview in Xcode a `UIViewController`.
///
/// ```swift
/// struct YourViewController_Previews: PreviewProvider {
///     static var previews: some View {
///         ViewControllerPreview(YourViewController())
///     }
/// }
/// ```
///
/// - SeeAlso: ``NavigationControllerPreview``
/// - SeeAlso: ``TabBarControllerPreview``
public struct ViewControllerPreview: UIViewControllerRepresentable {
  /// The view controller being previewed.
  public let viewController: UIViewController
  
  /// Creates a view controller preview.
  ///
  /// - Returns: The initialized preview object.
  public init(_ viewController: UIViewController) {
    self.viewController = viewController
  }
  
  public func makeUIViewController(context: Context) -> some UIViewController { viewController }
  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

import SwiftUI

/// A type that can be used to preview in Xcode a `UIView`.
///
/// ```swift
/// struct YourView_Previews: PreviewProvider {
///     static var previews: some View {
///         ViewPreview(YourView())
///             .previewLayout(.fixed(width: 375, height: 86))
///     }
/// }
/// ```
///
/// - Important: For the best possible previewing of a standalone view, you should set the `.previewLayout` values to be the expected in-app sizes of your view.
/// - SeeAlso: ``ViewControllerPreview``
public struct ViewPreview: UIViewRepresentable {
  /// The view being previewed.
  public let view: UIView
  
  /// Creates a view preview.
  ///
  /// - Returns: The initialized preview object.
  public init(_ view: UIView) {
    self.view = view
  }
  
  public func makeUIView(context: Context) -> some UIView { view }
  public func updateUIView(_ uiView: UIViewType, context: Context) {}
}

extension UIViewController {
  public func previewed() -> some View {
    ViewControllerPreview(self)
  }
}

extension UIView {
  public func previewed() -> some View {
    ViewPreview(self)
  }
}

extension View {
  public func embedInNavigation() -> some View {
    return NavigationView {
      self
    }
  }
}
