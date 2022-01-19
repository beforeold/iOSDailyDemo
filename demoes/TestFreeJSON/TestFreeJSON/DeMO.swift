//
//  DeMO.swift
//  TestFreeJSON
//
//  Created by BrookXy on 2022/1/13.
//

import Foundation


let orangeJsonString = """
"""


@dynamicMemberLookup
public enum FreeJSON {
    case dict([String: Any])
    case array([Any])
    case value(Any)
    case none
    
    public init(_ value: Any?) {
        guard let value = value else {
            self = .none
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

    public subscript(_ key: String) -> FreeJSON {
        return self[dynamicMember: key]
    }
    
    public subscript(_ index: Int) -> FreeJSON {
        switch self {
        case .array(let array):
            if index < array.count {
                return FreeJSON(array[index])
            } else {
                return .none
            }
            
        default:
            return .none
        }
    }
    
    public func get<T>(as type: T.Type) -> T? {
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

    public subscript(dynamicMember dynamicMember: String) -> FreeJSON {
        switch self {
        case .dict(let dict):
            return FreeJSON(dict[dynamicMember])
        default:
            return .none
        }
    }
}

public extension FreeJSON {
    init(data: Data) {
        let value = try? JSONSerialization.jsonObject(with: data, options: [])
        self.init(value)
    }
    
    init(jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else {
            self = .none
            return
        }
        
        self.init(data: data)
    }
}

public extension FreeJSON {
    var first: FreeJSON {
        if case .array(let array) = self {
            return array.first.map { FreeJSON($0) } ?? .none
        }
        return .none
    }
    
    var last: FreeJSON {
        if case .array(let array) = self {
            return array.last.map { FreeJSON($0) } ?? .none
        }
        return .none
    }
}

public extension FreeJSON {
    var string: String? {
        switch self {
        case .value(let value):
            return try? ValueCaster.string.cast(value)
        default:
            return nil
        }
    }
    
    var int: Int? {
        switch self {
        case .value(let value):
            return try? ValueCaster.int.cast(value)
        default:
            return nil
        }
    }
    
    var double: Double? {
        switch self {
        case .value(let value):
            return try? ValueCaster.double.cast(value)
        default:
            return nil
        }
    }
    
    var bool: Bool? {
        switch self {
        case .value(let value):
            return try? ValueCaster.bool.cast(value)
        default:
            return nil
        }
    }
}


public struct FreeJSONStringDecoder<Output>: StringDecoding {
    private let decoder: (FreeJSON) throws -> Output
    
    public func decode(string: String) throws -> Output {
        let json = FreeJSON(jsonString: string)
        return try decoder(json)
    }
    
    /// an initializer which takes a decoder with nullable output
    ///
    /// - Note: decoder will throw a DecodingFailure.noValue when get null ouput
    public init(_ decoder: @escaping (FreeJSON) throws -> Output?) {
        self.decoder = { text -> Output in
            guard let output = try decoder(text) else {
                throw DecodingFailure.noValue
            }
            return output
        }
    }
}



public protocol StringDecoding {
    associatedtype Output
    func decode(string: String) throws -> Output
}

public enum DecodingFailure: Error {
    case unexpectedType
    case noValue
}

/// a caster for number and string cases
/// which also could be used as  a stringDecoder
public struct ValueCaster<Output> {
    public let onNumber: (NSNumber) -> Output
    public let onString: (NSString) -> Output
    
    public init(onNumber: @escaping (NSNumber) -> Output,
                onString: @escaping (NSString) -> Output) {
        self.onNumber = onNumber
        self.onString = onString
    }
    
    public func cast(_ value: Any?) throws -> Output {
        guard let value = value else {
            throw DecodingFailure.noValue
        }
        
        if let value = value as? Output {
            return value
        }
        
        if let number = value as? NSNumber {
            return onNumber(number)
        }
        
        if let string = value as? NSString {
            return onString(string)
        }
        
        throw DecodingFailure.unexpectedType
    }
}

extension ValueCaster: StringDecoding {
    public func decode(string: String) throws -> Output {
        return try cast(string)
    }
}

extension ValueCaster where Output == Bool {
    public static let bool = ValueCaster(onNumber: { $0.boolValue }, onString: { $0.boolValue })
}

extension ValueCaster where Output == Int {
    public static let int = ValueCaster(onNumber: { $0.intValue }, onString: { Int($0.intValue) })
}

extension ValueCaster where Output == Double {
    public static let double = ValueCaster(onNumber: { $0.doubleValue }, onString: { $0.doubleValue })
}

extension ValueCaster where Output == String {
    public static let string = ValueCaster(onNumber: { $0.stringValue }, onString: { $0 as String })
}
