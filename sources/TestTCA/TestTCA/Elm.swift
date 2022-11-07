//
//  Elm.swift
//  TestTCA
//
//  Created by beforeold on 2022/11/7.
//

import SwiftUI

struct Elm {
    enum Msg {
      case increment
      case decrement
    }
    
    enum Cmd<Msg> {
        case some(Msg)
        case none
    }
    
    var model: Model
    
    func sendMsg(_ msg: Msg) {
        _ = update(msg: msg, model: model)
    }

    typealias Model = Int
    func update(msg: Msg, model: Model) -> (Model, Cmd<Msg>) {
      switch msg {
      case .increment:
        return (model + 1, .none)
      case .decrement:
        return (model - 1, .none)
      }
    }

    func view(model: Model) -> some View {
      HStack {
        Button("-") { sendMsg(.decrement) }
        Text("\(model)")
        Button("+") { sendMsg(.increment) }
      }
    }
}
