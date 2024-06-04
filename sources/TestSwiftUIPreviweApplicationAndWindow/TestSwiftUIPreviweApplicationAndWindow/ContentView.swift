//
//  ContentView.swift
//  TestSwiftUIPreviweApplicationAndWindow
//
//  Created by xipingping on 6/4/24.
//

import SwiftUI

class MyViewContent: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .yellow
  }
}

struct ContentView: View {
  var body: some View {
    Button("Tap") {
      //
    }
    .fullScreenCover(isPresented: .constant(true)) {
      Button("Tap Me") {
        let controller = MyViewContent()
        let rootVC = UIViewController.topViewController()
        rootVC?.present(controller, animated: true)
      }
    }
    .padding()
    .onAppear {
      print("")
      print("application", UIApplication.shared)
      print("delegate", UIApplication.shared.delegate?.description ?? "null")
      print("windows count", UIApplication.shared.windows.count)
      print("scene window", self.sceneWindow?.description ?? "null")
      print("current window", UIWindow.currentWindow()?.description ?? "nulll")
      print("delegate window", UIApplication.shared.delegate?.window??.description ?? "null")
      // print("key window", UIApplication.shared.keyWindow?.description ?? "null")
      print("rootVC", UIApplication.shared.windows.first?.rootViewController?.description ?? "null")
      print("topVC", UIViewController.topViewController() ?? "null")
    }
  }

  private var sceneWindow: UIWindow? {
    let activeScenes = UIApplication.shared.connectedScenes
      .filter({ $0.activationState == .foregroundActive })
      .compactMap({ $0 as? UIWindowScene })
    if let window = activeScenes.first?.windows.filter(\.isKeyWindow).first {
      return window
    }
    return nil

  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
