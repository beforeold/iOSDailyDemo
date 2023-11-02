//
//  Store.swift
//  TestUnidirectionalFlow
//
//  Created by Brook_Mobius on 11/1/23.
//

import Foundation
import CustomDump

final class Store<State, Action>: ObservableObject {
  @Published private(set) var state: State

  private let reduce: (State, Action) -> State

  init(
    initialState state: State,
    reduce: @escaping (State, Action) -> State
  ) {
    self.state = state
    self.reduce = reduce
  }

  func send(_ action: Action) {
    // state = reduce(state, action)
    send2(action)
  }


  func send2(_ action: Action) {
    let oldState = state
    state = reduce(state, action)
    let value = diff(oldState, state) ?? "null"
    print(action, value)
  }
}
