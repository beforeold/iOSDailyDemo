//
//  Person.swift
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
        
        enum CodingKeys: CodingKey {
            case value, some, opt
        }
        
        init(from decoder: Decoder) throws {
            let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
            self.value = try keyedContainer.decode(String.self, forKey: .value)
            self.some = try keyedContainer.decode(Int.self, forKey: .some)
            self.opt = try keyedContainer.decodeIfPresent(Int.self, forKey: .opt)
        }
    }
    
    var name: String
    var age: Int
    var inner: Inner
    var array: [Int]
    var array2: [Inner]
    var some: T
    
    @IntValue
    var age2: Int
    
    enum CodingKeys: CodingKey {
        case name, age, inner, array, array2, some, age2
    }
    
    init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try keyedContainer.decode(String.self, forKey: .name)
        self.age = try keyedContainer.decode(Int.self, forKey: .age)
        self.inner = try keyedContainer.decode(Inner.self, forKey: .inner)
        
        var arrayUnkeyedContainer = try keyedContainer.nestedUnkeyedContainer(forKey: .array)
        var array = [Int]()
        while !arrayUnkeyedContainer.isAtEnd {
            let ret = try arrayUnkeyedContainer.decode(Int.self)
            array.append(ret)
        }
        self.array = array
        
        self.array2 = try keyedContainer.decode([Inner].self, forKey: .array2)
        
        self.some = try keyedContainer.decode(T.self, forKey: .some)
        
        self._age2 = try keyedContainer.decode(IntValue.self, forKey: .age2)
    }
}


extension Array where Element: Codable {
    init(from decoder: Decoder) throws {
        var arrayUnkeyedContainer = try decoder.unkeyedContainer()
        var array = [Element]()
        while !arrayUnkeyedContainer.isAtEnd {
            let ret = try arrayUnkeyedContainer.decode(Element.self)
            array.append(ret)
        }
        self = array
    }
}
