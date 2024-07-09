//
//  ContentView.swift
//  TestUIViewWrapperUpdate
//
//  Created by xipingping on 7/9/24.
//

import SwiftUI

struct UIViewWrapper: UIViewRepresentable {
  let view: UIView
  let color: UIColor

  func makeUIView(context: Context) -> UIView {
    print("makeUIView")

    let view = self.view
    view.backgroundColor = color

    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) {
    uiView.backgroundColor = color
    print("update")
  }
}

struct ContentView: View {
  @State private var color: UIColor = .red

  @State var id = UUID()

  var body: some View {
    VStack {
      UIViewWrapper(view: .init(), color: color)
        .onTapGesture {
          print("on tap")
          self.color = .blue
//          self.id = UUID()
        }
    }
    .padding()
//    .id(id)
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
