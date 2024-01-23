//
//  OverlaySheet.swift
//  TestOverlaySheet
//
//  Created by Brook_Mobius on 1/22/24.
//

import SwiftUI
import UIKit

extension View {
  public func overlaySheet<Content: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder content: () -> Content
  ) -> some View {
    Text("")
  }
}

struct OverlaySheet: UIViewControllerRepresentable {
  @Binding var isPresented: Bool

  func makeUIViewController(context: Context) -> UIViewController {
    return UIViewController()
  }

  func updateUIViewController(
    _ uiViewController: UIViewController,
    context: Context
  ) {
    if self.isPresented {


    } else {
      uiViewController.dismiss(animated: true)
    }
  }
}

#Preview {
//  OverlaySheet()
  Text("111")
}
