//
//  Redux.swift
//  TestRedux
//
//  Created by beforeold on 2022/11/10.
//

import Foundation

public typealias Effect<Action> = Promise<Action>

public typealias Reducer<State, Action> = (_ state: inout State, _ action: Action) -> Effect<Action>?

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
    guard let effect = reducer(&state, action) else {
      return
    }
    
    effect.observe { [weak self] result in
      guard let self = self,
            let action = try? result.get() else {
        return
      }
      self.send(action)
    }
  }
}
