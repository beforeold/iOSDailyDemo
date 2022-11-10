//
//  Redux.swift
//  TestRedux
//
//  Created by beforeold on 2022/11/10.
//

import Foundation

public struct Effect {
  
}

public typealias Reducer<State, Action> = (_ state: inout State, _ action: Action) -> Effect?

public class Store<State, Action> {
  public var stateUpdateCallback: (State) -> Void = { _ in }
  
  private(set) var state: State {
    didSet {
      stateUpdateCallback(state)
    }
  }
  
  private let reducer: Reducer<State, Action>
  
  public init(
    initialState: State,
    reducer: @escaping Reducer<State, Action>
  ) {
    self.state = initialState
    self.reducer = reducer
  }
  
  public func send(_ action: Action) {
    let effect = reducer(&state, action)
    print(effect as Any)
  }
}

