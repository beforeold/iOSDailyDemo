//
//  WithViewStore.swift
//  TestRedux
//
//  Created by beforeold on 2022/11/10.
//

import SwiftUI

public class ViewStore<State, Action>: ObservableObject {
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
  private var store: ViewStore<State, Action>
  
  private let contentBuilder: (_ viewStore: ViewStore<State, Action>) -> Content
  
  public init(
    store: Store<State, Action>,
    contentBuilder: @escaping (_ viewStore: ViewStore<State, Action>
    ) -> Content) {
    self.store = ViewStore(store: store)
    self.contentBuilder = contentBuilder
  }
  
  public var body: some View {
    contentBuilder(store)
  }
}


struct WithStoreView_Previews: PreviewProvider {
  struct State {
    var name: String = "Redux"
  }
  
  enum Action {
    case buttonTap
  }
  
  fileprivate static func appendReducer<State, Action>(
    _ state: inout State,
    _ action: Action
  ) -> Effect<Action>? {
    return nil
  }
  
  static var previews: some View {
    WithStoreView(
      store: Store<State, Action>.init(
        initialState: State.init(),
        reducer: appendReducer
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
