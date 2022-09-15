//
//  Meta.swift
//  TestDictStringCodable
//
//  Created by 席萍萍Brook.dinglan on 2021/11/1.
//

import Foundation


enum Mock: Error { case decoding }

struct Meta<Model: Codable>: Codable {
    var model: Model
    var dict: [String: Any]
    
    init(from: Decoder) throws {
        throw Mock.decoding
    }
    
    func encode(to encoder: Encoder) throws {
        throw Mock.decoding
    }
}

struct EmptyModel: Codable { }

typealias Dict = Meta<EmptyModel>

struct Person {
    var properties: JSONString<Dict>
}

func foo() {
    let person: Person? = nil
    _ = person?.properties.base.dict
}
