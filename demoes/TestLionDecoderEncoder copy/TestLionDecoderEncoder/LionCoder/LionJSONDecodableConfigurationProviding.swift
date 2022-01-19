//
//  LionJSONDecoderAdapting.swift
//  TestLionDecoderEncoder
//
//  Created by 席萍萍Brook.dinglan on 2021/11/24.
//

import Foundation

public protocol LionJSONDecodableConfigurationProviding {
    static func guardBool(
        from decoder: Decoder,
        value: JSONValue?,
        for additionalKey: CodingKey?) -> Bool
    
    static func guardString(
        from decoder: Decoder,
        value: JSONValue?,
        for additionalKey: CodingKey?) -> String
    
    static func guardFixedWidthInteger<T: FixedWidthInteger>(
        from decoder: Decoder,
        value: JSONValue?,
        for additionalKey: CodingKey?,
        as type: T.Type) -> T
    
    static func guardFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(
        from decoder: Decoder,
        value: JSONValue?,
        for additionalKey: CodingKey?,
        as type: T.Type) -> T
}

public extension LionJSONDecodableConfigurationProviding {
    // key not found
    // value not found
    // mismatch
    // dataCorrupted，如 3.5 -> 4
    
    // 回调
    // nil 打标没有命中
    // Bool 没法处理的 string, object, array
    // string 没法处理的 bool, array, object
    // int/double 没法处理的 string,
    
    static func guardBool(
        from decoder: Decoder,
        value: JSONValue?,
        for additionalKey: CodingKey?) -> Bool {
            return true
        }
    
    static func guardString(
        from decoder: Decoder,
        value: JSONValue?,
        for additionalKey: CodingKey?) -> String {
            return ""
        }
    
    static func guardFixedWidthInteger<T: FixedWidthInteger>(
        from decoder: Decoder,
        value: JSONValue?,
        for additionalKey: CodingKey?,
        as type: T.Type) -> T {
            return 0
        }
    
    static func guardFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(
        from decoder: Decoder,
        value: JSONValue?,
        for additionalKey: CodingKey?,
        as type: T.Type) -> T {
            return 0
        }
}

struct LionJSONDecodableDefaultConfigurationProvider: LionJSONDecodableConfigurationProviding {

    
}


protocol MayThrowable {
    func fails() throws
}

struct NeverFail: MayThrowable {
    func fails() {
    }
}


// MARK: - demo
/*
#if DEBUG
 
 
 let value = try? MockDecoder().decode(SomeModel.self, forKey: .name)
 print("mock decoder", value as Any)


struct MockDecoder {
    
    let dict: [String: String] = ["key_key": "value"]
    
    func decode(_ type: SomeModel.Type, forKey key: SomeModel.CodingKeys) throws -> String? {
        let string = getMappedString(type: type, for: key)
        
        guard let value = dict[string] else {
            throw DecodingError.keyNotFound(key, .init(codingPath: [], debugDescription: "no value", underlyingError: nil))
        }
        return value
    }
    
    func getMappedString(type: Any.Type, for key: CodingKey) -> String {
        if let t = type as? LionJSONDecodableConfigurationProviding.Type {
            if let string = t.keyMapping[key.stringValue] {
                return string
            }
        }
        return key.stringValue
    }
    
    func mockDecodingConfig<T: Decodable>(type: T) {
        
        if let type = type as? LionJSONDecodableConfigurationProviding.Type {
            type.foo()
        }
    }
}


struct SomeModel: Codable {
    var name: String
    
    enum CodingKeys: CodingKey {
        case name
    }
}

extension SomeModel: LionJSONDecodableConfigurationProviding {
    
    static var keyMapping: [String : String] = [
        CodingKeys.name.stringValue : "key_key"
    ]
    
    static func foo() {
        
    }

}

#endif
 */
