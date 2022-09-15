//
//  main.swift
//  TestDictStringCodable
//
//  Created by 席萍萍Brook.dinglan on 2021/10/30.
//

import Foundation

func toDict(data: Data) -> NSDictionary? {
    try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
}

func toData(dict: NSDictionary) -> Data? {
    try? JSONSerialization.data(withJSONObject: dict, options: [])
}

func toString(dict: NSDictionary) -> String? {
    let data = toData(dict: dict)
    let string = data.flatMap { data in
        String(data: data, encoding: .utf8)
    }
    
    return string
}

// {\"key2\":\"value2\"}

let jsonString =
"""
{"key1":"{\"key2\":\"value2\"}"}
"""

// key using jsonString
// {\"key1\":"{\"key2\":\"value2\"}"}

// normal dict
// {\"key1\":{\"key2\":\"value2\"}}


public struct JSONString<Base: Codable>: Codable {
    var base: Base
    
    public init(base: Base) {
        self.base = base
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let jsonString = try container.decode(String.self)
        let data = jsonString.data(using: .utf8) ?? Data()
        self.base = try JSONDecoder().decode(Base.self, from: data)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let data = try JSONEncoder().encode(base)
        let jsonString = String(data: data, encoding: .utf8) ?? ""
        try container.encode(jsonString)
    }
}

struct Model: Codable {
    struct Inner: Codable {
        var key2: String
    }
    
    var key1: JSONString<Inner>
}

/*
extension Model: Decodable {
    enum CodingKeys: CodingKey {
        case key1
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let jsonString = try container.decode(String.self, forKey: .key1)
        let data = jsonString.data(using: .utf8) ?? Data()
        self.key1 = try JSONDecoder().decode(Inner.self, from: data)
    }
}
*/

func decodeJsonString() {
    /// make dict to jsonString
    let inner = ["key2": "value2"] as NSDictionary
    let jsonString = toString(dict: inner)!
    
    let outer = ["key1": jsonString] as NSDictionary
    let outerString = toString(dict: outer)!
    
    let data = outerString.data(using: .utf8)!
    print(toDict(data: data)!)
    
    do {
        let model = try JSONDecoder().decode(Model.self, from: data)
        print(model.key1.base.key2)
    } catch {
        print(error)
    }
}

// decodeJsonString()

func testJSONString() {
    let ins = Model(key1: JSONString(base: .init(key2: "value2")))
    let data = try! JSONEncoder().encode(ins)
    print(toDict(data: data)!)
    let ins2 = try! JSONDecoder().decode(Model.self, from: data)
    print(ins2.key1.base.key2)
}

testJSONString()

// print(toString(dict: ["key1": ["key2": "value2"]]) as Any)
