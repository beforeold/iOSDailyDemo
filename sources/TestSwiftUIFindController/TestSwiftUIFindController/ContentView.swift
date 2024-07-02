//
//  ContentView.swift
//  TestSwiftUIFindController
//
//  Created by xipingping on 7/2/24.
//

import SwiftUI

struct UIViewWrapper: UIViewRepresentable {
  let view: UIView
  func makeUIView(context: Context) -> UIView { view }
  func updateUIView(_ uiView: UIView, context: Context) {
    var view: UIView? = uiView

    while view?.superview != nil {
      print((view?.superview)!)
      view = view?.superview
    }
  }
}

struct UIViewControllerWrapper: UIViewControllerRepresentable {
  let view: UIViewController
  func makeUIViewController(context: Context) -> UIViewController { view }

  /// log the next responder chain
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    print("update")

    var view: UIResponder? = uiViewController
    while view?.next != nil {
      print((view?.next)!)
      view = view?.next
    }
  }
}


struct SubView: View {
  var body: some View {
    Text("SubView")
  }

  func getViewController() {

  }
}

struct RootView: View {
  var body: some View {
    SubView()
  }
}

func foo() {
  let controller = UIHostingController(rootView: RootView())
  // show the controller
}

struct ContentView: View {
  var body: some View {
    VStack {
//      UIViewWrapper(view: UIView())
//      UIViewControllerWrapper(view: UIViewController())


    }
    .padding()
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
