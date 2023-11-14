//
//  ContentView.swift
//  TestObservableMainActor
//
//  Created by Brook_Mobius on 11/14/23.
//

import SwiftUI
import Observation

@MainActor
@Observable
class ViewModel {
  var name = "brook"

  func printName() {

  }

  @MainActor
  func foo() {

  }

  var myName: String {
    return name
  }
}

@MainActor
extension ViewModel {
  func bar() {

  }
}

protocol ViewBP: View {
  associatedtype BodyBP: View
  @ViewBuilder @MainActor var bodyBP: Self.BodyBP { get }
}

extension ViewBP {
  @MainActor var body: some View {
    Group {
      bodyBP
    }
  }
}

@MainActor struct ContentView: ViewBP {
  var model = ViewModel()

  var bodyBP: some View {
    VStack {
      Text(model.name)

      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")

      Button("tap") {
        model.foo()
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
