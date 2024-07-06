//
//  ContentView.swift
//  TestMenuState
//
//  Created by beforeold on 7/1/24.
//

import SwiftUI

struct MenuView: View {
  @State private var flag: Bool = false

  @StateObject private var model = Model()

  var value: Int

  var index: Int

  var onPlusTapped: () -> Void

  var body: some View {
    Picker("Flag", selection: $model.flag) {
      Text("on")
        .tag(true)
      Text("off")
        .tag(false)
    }
    .id(index)

    Button("Plus: (\(self.value))") {
      onPlusTapped()
    }
    .onAppear {
      print("appear")
    }

    if value > 0 {
      // Text("hello")
      EmptyView()
        .onAppear(perform: {
          print("hello")
        })
    }
  }
}

class Model: ObservableObject {
  @Published var flag = false
}

struct ContentView: View {
  @State private var index = 0
  @State private var value = 0

  var body: some View {
//    List(0..<10) { index in
//      Text(index.description)
//        .contextMenu {
//          MenuView(index: index)
//            .id(index)
//        }
//    }
    self.body1
  }

  var body1: some View {
    Menu {
      MenuView(value: value, index: index) {
        self.value += 1
      }
    } label: {
      Text("Menu")
    }
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
