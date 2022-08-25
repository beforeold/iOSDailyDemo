//
//  main.swift
//  TestCodable
//
//  Created by dinglan on 2021/6/10.
//

import Foundation

print("Hello, World!")

struct BoolBool: Decodable {
    
}

@propertyWrapper
struct DefaultValue<T: Decodable> {
    var wrappedValue: T

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}


extension DefaultValue: Decodable {
    
}

struct A {
    struct Video: Decodable {
        let id: Int
        let title: String
        let commentEnabled: Bool

        enum CodingKeys: String, CodingKey {
            case id, title, commentEnabled
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            title = try container.decode(String.self, forKey: .title)
            commentEnabled = try container.decodeIfPresent(Bool.self, forKey: .commentEnabled) ?? false
        }
    }
}

struct B {
    struct Video: Decodable {
        var id: Int
        var title: String
        
        @DefaultValue
        var commentEnabled = 3
    }
//
//    func hh() {
//        let a = Thread.current.lastCodableWrapper
//    }
    
}
