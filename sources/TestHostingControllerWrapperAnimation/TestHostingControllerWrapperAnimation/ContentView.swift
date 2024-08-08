//
//  ContentView.swift
//  TestHostingControllerWrapperAnimation
//
//  Created by Brook_Mobius on 7/10/24.
//

import SwiftUI


struct SomeView: View {
  var color: Color

  var body: some View {
    color
  }
}

struct ControllerWrapper: UIViewControllerRepresentable {
  let controller: UIViewController
  init(controller: UIViewController) {
    self.controller = controller
  }

  func makeUIViewController(context: Context) -> some UIViewController {
    self.controller
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

  }
}

struct ContentView: View {
  let hostController: UIHostingController<SomeView> = .init(
    rootView: .init(color: .red)
  )

  var body: some View {
    VStack {
      ControllerWrapper(controller: hostController)
    }
    .onTapGesture {
      withAnimation(.easeOut(duration: 3)) {
        hostController.rootView = .init(
          color: .blue
        )
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
