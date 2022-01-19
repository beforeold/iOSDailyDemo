//
//  main.swift
//  TestJSONDecoder
//
//  Created by 席萍萍Brook.dinglan on 2021/8/20.
//

import Foundation

struct Person: Codable {
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
    }
}

func foo() {
    let decoder = JSONDecoder()
    let string = """
    {"name":"kevin"}
    """
    
    if let data = string.data(using: .utf8) {
        let p = try? decoder.decode(Person.self, from: data)
        print(p as Any)
    }
}

func foo2() {
    let decoder = JSONDecoder()
    let string = """
    "1"
    """
    
    if let data = string.data(using: .utf8) {
        let p = try? decoder.decode(Bool.self, from: data)
        print(p as Any)
    }
}

foo2()





