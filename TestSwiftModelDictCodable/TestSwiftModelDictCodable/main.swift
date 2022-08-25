//
//  main.swift
//  TestSwiftModelDictCodable
//
//  Created by 席萍萍Brook.dinglan on 2021/10/11.
//

import Foundation

struct Meta<Model: Decodable> {
    var model: Model
    var dict: [String: Any]
}



extension Meta: Decodable {
    init(from decoder: Decoder) throws {
        // decode model ...
        self.model = try decoder.singleValueContainer().decode(Model.self)
        
        // decode dict ...
        let container = try decoder.container(keyedBy: JSONCodingKeys.self)
        self.dict = try container.decode([String: Any].self)
    }
}

extension Meta: Encodable {
    public func encode(to encoder: Encoder) throws {
        // encode with the dictionary
        var container = encoder.container(keyedBy: JSONCodingKeys.self)
        try container.encode(dict)
    }
}


struct OuterModel: Decodable {
    var k1: String?
    var k2: String?
    
    var inner: Meta<InnerModel>?
}

struct InnerModel: Decodable {
    var k1: String?
    var k2: String?
}

let data = Data()
let type = Meta<OuterModel>.self
let model = try? JSONDecoder().decode(type, from: data)


let outerModel = model?.model.inner?.model


struct DemoKeyValue: Decodable {
    var key1: String?
    
    var inner1: Meta<DemoKeyValue2>?
}

struct DemoKeyValue2: Decodable {
    var key2: String
    
    var inner2: Meta<DemoKeyValue3>?
}

struct DemoKeyValue3: Decodable {
    var key3: String
}


let str = """
{"key1":"value1", "inner": {"key2":"value2"}}
"""
if let jsonData = str.data(using: .utf8) {
    let type = Meta<DemoKeyValue>.self
    let kv = try? JSONDecoder().decode(type, from: jsonData)
    
    print(kv?.model as Any)
    print(kv?.dict as Any)
    
    print(kv?.model.inner1?.model as Any)
    print(kv?.model.inner1?.dict as Any)
}

struct Person: Codable {
    var name: String
}


let meta1 = Meta(model: Person(name: "brook"),
                 dict: ["name": "brook"])

let data1 = try! JSONEncoder().encode(meta1)
let meta2 = try! JSONDecoder().decode(Meta<Person>.self, from: data1)
print(meta2.model)
