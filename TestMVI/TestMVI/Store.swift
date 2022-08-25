//
//  Store.swift
//  TestMVI
//
//  Created by 席萍萍Brook.dinglan on 2021/12/30.
//

import Foundation


class Store: Observerable {
    static let shared = Store(state: InitialState())
    
    var value: State
    var callbackList = [(State) -> ()]()
    
    init(state: State) {
        self.value = state
    }
    
    func accept(_ value: State) {
        
    }
}
























protocol Observerable {
    associatedtype Value
    var callbackList: [(Value) -> ()] { get mutating set }
    var value: Value { mutating set get }
    
    mutating func accept(_ value: Value)
    mutating func observe(callback: @escaping (Value) -> ())
}

extension Observerable {
    mutating func accept(_ value: Value) {
        self.value = value
        
        callbackList.forEach { callback in
            callback(value)
        }
    }
    
    mutating func observe(callback: @escaping (Value) -> ()) {
        callbackList.append(callback)
        callback(value)
    }
}
