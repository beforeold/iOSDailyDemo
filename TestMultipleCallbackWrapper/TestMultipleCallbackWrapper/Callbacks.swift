//
//  Callbacks.swift
//  TestMultipleCallbackWrapper
//
//  Created by BrookXy on 2022/5/7.
//

import Foundation

public class Callbacks<T> {
    public typealias Callback = (T) -> Void
    
    private var callbacks: [Callback] = []
    
    public init() {
        // none
    }

    /// add callback
    public func callAsFunction(callback: @escaping Callback) {
        callbacks.append(callback)
    }
    
    /// send intput, invoke callbacks
    public func callAsFunction(_ input: T) {
        callbacks.forEach {
            $0(input)
        }
    }
}

public extension Callbacks where T == Void {
    func callAsFunction() {
        callAsFunction(())
    }
}
