//
//  ContentView.swift
//  TestUiPresentation
//
//  Created by Brook_Mobius on 1/22/24.
//

import SwiftUI

struct ContentView: View {
  @State private var showsSheet = false

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")

      Button("show sheeet") {
        self.showsSheet = true

        UIPresentationController.setup()
        
        let rootVC = UIApplication.shared.windows.first?.rootViewController
        print(rootVC)

        let controller = UIViewController()
        controller.view.backgroundColor = .blue
//        rootVC?.present(controller, animated: true)
      }
    }
    .padding()
    .sheet(isPresented: self.$showsSheet) {
      Text("this is a sheet")
    }
  }
}

#Preview {
  ContentView()
}
