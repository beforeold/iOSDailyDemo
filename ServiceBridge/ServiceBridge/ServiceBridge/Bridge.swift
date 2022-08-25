//
//  Bridge.swift
//  ServiceBridge
//
//  Created by 席萍萍Brook.dinglan on 2021/9/30.
//

import Foundation

public enum BridgeError: Error {
    case noTarget
    case unexpectedAction
    case unexpectedOutput
}

public final class Bridge {
    typealias ReturnPair<Output> = (target: NSObject, output: Output)
    
    public static let shared = Bridge()
    
    //// !! swift 的 perform 可以返回值类型吗？
    ///
    /// defined a dictionary to wrap value types like CGRect
    @discardableResult
    func perform<Output>(outputType: Output.Type,
                         targetName: String,
                         actionName: String,
                         targetObject: NSObject? = nil,
                         params: [AnyHashable: Any]? = nil) throws -> ReturnPair<Output>
    {
        let target: NSObject
        if let targetObject = targetObject {
            target = targetObject
        } else {
            guard let clz = NSClassFromString(targetName) as? NSObject.Type else {
                throw BridgeError.noTarget
            }
            target = clz.init()
        }
        
        let sel = NSSelectorFromString(actionName)
        guard target.responds(to: sel) else {
            throw BridgeError.unexpectedAction
        }
        
        let returned = target.perform(sel, with: params)
        let dict = returned?.takeUnretainedValue() as? [AnyHashable : Any]
        
        guard let unboxed = dict?["boxed"] as? Output else {
            throw BridgeError.unexpectedOutput
        }
        
        return (target, unboxed)
    }
}
