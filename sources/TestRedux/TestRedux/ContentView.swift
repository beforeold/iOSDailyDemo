//
//  ContentView.swift
//  TestRedux
//
//  Created by beforeold on 2022/11/10.
//

import SwiftUI

fileprivate enum Action {
  case tap
}

fileprivate func reducer(
  _ state: inout Int,
  _ action: Action
) -> Effect? {
  state += 10
  return nil
}

fileprivate let store = Store<Int, Action>(
  initialState: 666,
  reducer: reducer
)

struct ContentView: View {
  @State var count = 0
  
  var body: some View {
    WithStoreView(store: store) { viewStore in
      VStack(spacing: 20) {
        Text("value: \(viewStore.state)")
        Button("Tap") {
          viewStore.send(.tap)
        }
      }
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
