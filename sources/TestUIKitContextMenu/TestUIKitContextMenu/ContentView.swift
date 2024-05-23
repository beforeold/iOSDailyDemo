//
//  ContentView.swift
//  TestUIKitContextMenu
//
//  Created by xipingping on 5/22/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Rectangle()
        .frame(width: 100, height: 100)
        .overlay { ViewWrapper() }
    }
    .padding()
  }
}

struct ViewWrapper: UIViewRepresentable {
  class Coordinator: NSObject, UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
      _ interaction: UIContextMenuInteraction,
      configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
      .init(
        previewProvider: {
          let controller = UIViewController()
          controller.view.backgroundColor = .blue
          controller.preferredContentSize = CGSize(width: 200, height: 200)
          return controller
        }
      )
    }
  }

  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    view.backgroundColor = .clear

    let interaction = UIContextMenuInteraction(delegate: context.coordinator)
    view.addInteraction(interaction)

    return view
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {

  }

  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  typealias UIViewType = UIView


}


#Preview {
  ContentView()
}
