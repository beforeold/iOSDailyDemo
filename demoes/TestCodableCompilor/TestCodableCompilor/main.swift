//
//  main.swift
//  TestCodableCompilor
//
//  Created by 席萍萍Brook.dinglan on 2021/12/30.
//

import Foundation

fileprivate
struct Person<T: Codable>: Codable {
    struct Inner: Codable {
        var value: String
        var some: Int
        var opt: Int?
    }
    
    var name: String
    var age: Int
    var inner: Inner
    var array: [Int]
    var array2: [Inner]
    var some: T
    
    @IntValue
    var age2: Int
}

@propertyWrapper struct IntValue: Codable {
    var wrappedValue: Int
    
    init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        let ret = (try? singleValueContainer.decode(Int.self)) ?? 0
        self.wrappedValue = ret
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}
