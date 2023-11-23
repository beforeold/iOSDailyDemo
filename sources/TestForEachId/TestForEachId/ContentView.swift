//
//  ContentView.swift
//  TestForEachId
//
//  Created by Brook_Mobius on 11/23/23.
//

import SwiftUI

struct Person {
  var id: Int
  var name: String
}

class ViewModel: ObservableObject {


  @Published var items = [
    Person(id: 1, name: "a1"),
    Person(id: 2, name: "a2"),
    Person(id: 3, name: "a3"),
  ]

  func change() {
    items = [
      Person(id: 1, name: "b1"),
      Person(id: 2, name: "b2"),
      Person(id: 3, name: "b3"),
    ]
  }
}

struct ContentView: View {
  @StateObject var viewModel = ViewModel()

  @State var items = [
    Person(id: 1, name: "a1"),
    Person(id: 2, name: "a2"),
    Person(id: 3, name: "a3"),
  ]

  func change() {
    items = [
      Person(id: 1, name: "b1"),
      Person(id: 2, name: "b2"),
      Person(id: 3, name: "b3"),
    ]
  }

  var body: some View {
    let _ = Self._printChanges()

    VStack(spacing: 20) {
      ForEach(
        items.indices,
        id: \.self
      ) {
        let _ = print("item: ", $0)

        Text(items[$0].name)
      }

      Button("Change") {
        change()
      }
    }
    .padding()
  }
}


#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
