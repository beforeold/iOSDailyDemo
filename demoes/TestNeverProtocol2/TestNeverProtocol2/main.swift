//
//  main.swift
//  TestNeverProtocol2
//
//  Created by 席萍萍Brook.dinglan on 2021/8/21.
//

import Foundation


func foo(_ data: NSCoding) {
    
}

foo(Data() as NSData)

func bar() {
    UserDefaults.standard
}

//protocol AVFSProtocol {
//    func save<T: NSCoding>(value: T)
//}
//
//protocol UserDefaultsProtocol {
//    func save<T: Codable>(value: T)
//}


protocol CoderProotocol {
    associatedtype Value
}

protocol StorageProtocol {
    func container(type: )
}

protocol CacheProtocol {
    func save<Value>(value: Value)
    func load<Value>() -> Value?
}

struct JsonCoder: CoderProotocol {
    typealias Value = Codable
}

class AVFS: StorageProtocol {
    func load() -> Codable? {
        nil
    }
\
    func load<T: Codable>() -> T? {
        
        nil
    }
    
    func save(value: Codable) {
        
    }
    
    typealias Coder = JsonCoder
}

