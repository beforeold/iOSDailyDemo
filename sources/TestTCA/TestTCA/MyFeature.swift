//
//  MyFeature.swift
//  TestTCA
//
//  Created by Brook_Mobius on 2022/11/8.
//

import Foundation
import ComposableArchitecture

private func url(count: Int) -> URL {
  let url = URL(string: "http://numbersapi.com/\(count)/trivia")!
  return url
}


struct MyFeature: ReducerProtocol {
  struct State: Equatable {
    var count = 0
    var numberFactAlert: String?
  }
  
  enum Action: Equatable {
    case factAlertDismissed
    case decrementButtonTapped
    case incrementButtonTapped
    case numberFactButtonTapped
    case numberFactResponse(TaskResult<String>)
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .factAlertDismissed:
      state.numberFactAlert = nil
      return .none
    case .decrementButtonTapped:
      state.count -= 1
      return .none
    case .incrementButtonTapped:
      state.count += 1
      return .none
    case .numberFactButtonTapped:
      return .task { [count = state.count] in
        await .numberFactResponse(
          TaskResult {
            String(
              decoding: try await URLSession.shared
                .data(from: url(count: count)).0,
              as: UTF8.self
            )
          }
        )
      }
    case .numberFactResponse(.success(let fact)):
      state.numberFactAlert = fact
      return .none
      
    case .numberFactResponse(.failure):
      state.numberFactAlert = "Could not load a number fact :["
      return .none
    }
  }
}
