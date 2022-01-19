//
//  main.swift
//  TestRawRepresentableCodable
//
//  Created by 席萍萍Brook.dinglan on 2021/12/1.
//

import Foundation

struct StringState: RawRepresentable {
    var rawValue: String
}

extension StringState: Codable {
    
}

struct Person: Codable {
    var state: StringState
    
    var intEnum: IntEnum
    var stringEnum: StringEnum
}


struct LionInt: RawRepresentable {
    var rawValue: Int
}

let lion_unkown = 5525

enum IntEnum: Int, LionIntCodable {
    case a, b, c, lion_unkown = 5525
}

enum StringEnum: String, LionStringCodable {
    case a, b, c
}

protocol LionIntCodable: Codable, RawRepresentable {
    
}

protocol LionStringCodable: Codable, RawRepresentable {
    
}

//extension LionStringCodable {
//    init(from decoder: Decoder) {
//        self.init(rawValue: "" as! Self.RawValue)
//    }
//}


struct Default: Decodable {
    let value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = (try? container.decode(Int.self)) ?? 5
    }
}

extension KeyedDecodingContainerProtocol {
    func decode(
        _ type: Default.Type,
        forKey key: Key
    ) throws -> Default
    {
        let ret = try decodeIfPresent(type, forKey: key)
        return ret ?? Default(value: 5)
    }
    
    
    
    func decodeIfPresent(
        _ type: Default.Type,
        forKey key: Key
    ) throws -> Default?
    {
        return Default(value: 5)
        let ret = try decode(type, forKey: key)
        return ret ?? Default(value: 5)
    }
}

let data = Data("""
{"key": 444}
""".utf8)

struct Model: Decodable {
    let key: Default?
}

do {
    let ret = try JSONDecoder().decode(Model.self, from: data)
    print(ret)
}
