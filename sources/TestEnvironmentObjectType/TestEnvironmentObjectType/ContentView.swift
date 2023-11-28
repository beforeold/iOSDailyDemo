//
//  ContentView.swift
//  TestEnvironmentObjectType
//
//  Created by Brook_Mobius on 11/28/23.
//

import SwiftUI

class Object: ObservableObject {
  @Published var name = ""
}

struct ContentView: View {
  var body: some View {
    let view = makeView()
    let _ = print(type(of: view))

    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }

  // view  SwiftUI.ModifiedContent<SwiftUI.Text, SwiftUI._EnvironmentKeyWritingModifier<TestEnvironmentObjectType.Object?>>
  func makeView() -> some View {
    Text("hello")
      .environmentObject(Object())
  }
}

#Preview {
  ContentView()
}
