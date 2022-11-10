//
//  ContentView.swift
//  TestRedux
//
//  Created by beforeold on 2022/11/10.
//

import SwiftUI

fileprivate enum Action {
  case tap
  case later
  case laterCallback(Int)
}

fileprivate func reducer(
  _ state: inout Int,
  _ action: Action
) -> Effect<Action>? {
  switch action {
  case .tap:
    state += 10
    return .none
    
  case .later:
    return makeLaterPromise(state: state)
    
  case .laterCallback(let ret):
    state = ret
    return .none
  }
}

fileprivate func makeLaterPromise(state: Int) -> Promise<Action> {
  let promise = Promise<Action>()
  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    promise.resolve(with: .laterCallback(1000 + state))
  }
  
  return promise
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
        
        Button("Later Update") {
          viewStore.send(.later)
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
