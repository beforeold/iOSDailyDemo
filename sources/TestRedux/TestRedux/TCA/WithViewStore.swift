//
//  WithViewStore.swift
//  TestRedux
//
//  Created by beforeold on 2022/11/10.
//

import SwiftUI

public class SwiftUIStore<State, Action>: ObservableObject {
  private let store: Store<State, Action>
  
  @Published private(set) var state: State
  
  public init(store: Store<State, Action>) {
    self.store = store
    self._state = Published(initialValue: store.state)
    self.store.stateUpdateCallback = {[weak self] in
      self?.state = $0
    }
  }
  
  public func send(_ action: Action) {
    self.store.send(action)
  }
}

public struct WithStoreView<State, Action, Content: View>: View {
  @ObservedObject
  private var store: SwiftUIStore<State, Action>
  
  private let contentBuilder: (_ viewStore: SwiftUIStore<State, Action>) -> Content
  
  public init(
    store: Store<State, Action>,
    contentBuilder: @escaping (_ viewStore: SwiftUIStore<State, Action>
    ) -> Content) {
    self.store = SwiftUIStore(store: store)
    self.contentBuilder = contentBuilder
  }
  
  public var body: some View {
    contentBuilder(store)
  }
}

func emptyReducer<State, Action>(_ state: inout State, _ action: Action) -> Effect? {
  return nil
}

struct WithStoreView_Previews: PreviewProvider {
  struct State {
    var name: String = "Redux"
  }
  
  enum Action {
    case buttonTap
  }
  
  static var previews: some View {
    WithStoreView(
      store: Store<State, Action>.init(
        initialState: .init(),
        reducer: { state, action in
          state.name += " tapped"
          return .none
        }
      )
    ) { viewStore in
      VStack {
        Text("Hello \(viewStore.state.name)")
        Button("Tap") {
          viewStore.send(.buttonTap)
        }
      }
    }
  }
}
