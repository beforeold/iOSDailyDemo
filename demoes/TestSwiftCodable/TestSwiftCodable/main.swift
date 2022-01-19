//
//  main.swift
//  TestSwiftCodable
//
//  Created by 席萍萍Brook.dinglan on 2021/11/30.
//

import Foundation

enum Value<T: Decodable>: Decodable {
    case value(T)
    case expression(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 判断某种 case 进行 decode
        // dummy implementation
        if let string = try? container.decode(String.self) {
            self = .expression(string)
        } else {
            let ret = try container.decode(T.self)
            self = .value(ret)
        }
    }
}

struct Person: Codable {
    var name: String
    
    init(from decoder: Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self
                                     , forKey: .name)
    }
}

let data = Data("{\"name\":\"brook\"}".utf8)
_ = try JSONDecoder().decode(Person.self, from: data)

