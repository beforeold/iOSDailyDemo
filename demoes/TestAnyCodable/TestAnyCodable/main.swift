//
//  main.swift
//  TestAnyCodable
//
//  Created by 席萍萍Brook.dinglan on 2021/10/25.
//

import Foundation

print("Hello, World!")

@propertyWrapper
struct BoolValue<T> {
    let value: T
    init(value: T) {
        self.value = value
    }
    
    var wrappedValue: Bool {
        true
    }
}

extension BoolValue: Decodable {
    init(from decoder: Decoder) throws {
        
    }
}

struct Value: Decodable {
    @BoolValue<String> var flag: String
}
