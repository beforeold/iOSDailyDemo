//
//  ContentView.swift
//  TestMenuState
//
//  Created by beforeold on 7/1/24.
//

import SwiftUI

struct MenuView: View {
  var index: Int

  init(
    index: Int,
    flag: Bool = false
  ) {
    self.index = index
    self.flag = flag
  }

  @State private var flag = false

  var body: some View {
    Picker("Flag", selection: $flag) {
      Text("on")
        .tag(true)
      Text("off")
        .tag(false)
    }
    .id(index)
  }
}

struct ContentView: View {
  @State private var index = 0

  var body: some View {
    Menu {
      MenuView(index: index)
        .onAppear {
          print("on appear")
          self.index += 1
        }
    } label: {
      Text("Menu")
    }
  }
}

#Preview {
  ContentView()
}
