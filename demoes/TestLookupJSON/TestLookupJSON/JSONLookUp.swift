//
//  JSONLookUp.swift
//  JSONLookUp
//
//  Created by BrookXy on 2022/1/9.
//

import Foundation

@dynamicMemberLookup
enum JSON {
    case dict([String: Any])
    case array([Any])
    case value(Any)
    case none
    
    init(_ value: Any?) {
        guard let value = value else {
            self = JSON.none
            return
        }
        
        if let dict = value as? [String: Any] {
            self = .dict(dict)
        }
        else if let array = value as? [Any] {
            self = .array(array)
        }
        else {
            self = .value(value)
        }
    }
    
    subscript(_ key: String) -> JSON? {
        return self[dynamicMember: key]
    }
    
    subscript(_ index: Int) -> JSON? {
        switch self {
        case .array(let array):
            if index < array.count {
                return JSON(array[index])
            } else {
                return JSON.none
            }
            
        default:
            return JSON.none
        }
    }
    
    func get<T>(as type: T.Type) -> T? {
        switch self {
        case .array(let value):
            return value as? T
        case .dict(let value):
            return value as? T
        case .value(let value):
            return value as? T
        case .none:
            return nil
        }
    }
    
    var stringValue: String {
        let ret = get(as: Any.self)
        return (ret as? String) ?? "unknown_string_value"
    }
    
    subscript(dynamicMember dynamicMember: String) -> JSON? {
        switch self {
        case .dict(let dict):
            return JSON(dict[dynamicMember])
        default:
            return JSON.none
        }
    }
}

func undefined() -> Never {
    fatalError()
}

var pass: Never {
    fatalError()
}
