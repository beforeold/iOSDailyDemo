//
//  ContentView.swift
//  TestListMainActor
//
//  Created by xipingping on 4/23/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }

  // why can call the List initializer, it's MainActor struct
  // not checked restrictly
  func makeList() -> some View {
    List {

    }
  }

  func makeForm() -> some View {
    Form {

    }
  }
}

class Maker {
  func makeList() {
    Task { @MainActor in
      let _ = List {

      }
    }

    let _ = List {

    }
  }
}

#Preview {
  ContentView()
}
