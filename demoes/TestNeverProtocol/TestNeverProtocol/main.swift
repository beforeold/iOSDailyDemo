//
//  main.swift
//  TestNeverProtocol
//
//  Created by 席萍萍Brook.dinglan on 2021/8/20.
//

import Foundation

print("Hello, World!")


protocol CoderProtocol {
    associatedtype Value
    func encode(_ value: Value) throws -> Data
    func decode(from data: Data) throws -> Value
}

struct JsonCoder<T: Codable>: CoderProtocol {
    func encode(_ value: T) throws -> Data {
        try Foundation.JSONEncoder().encode(value)
    }
    
    func decode(from data: Data) throws -> T {
        try Foundation.JSONDecoder().decode(T.self, from: data)
    }
}

protocol StorageProtocol {
    func save<Coder: CoderProtocol>(value: Coder.Value?, for key: String, coder: Coder)
    func load<Coder: CoderProtocol>(with key: String, coder: Coder) -> Coder.Value?
}

extension Never: CoderProtocol {
    func encode(_ value: Never) -> Data {
        
    }
    
    func decode(from data: Data) -> Never {
        fatalError()
    }
    
    typealias T = Never
}

@propertyWrapper
struct Storage<Coder: CoderProtocol> {
    let storage: StorageProtocol
    let coder: Coder
    let key: String
    
    typealias Value = Coder.Value
    
    init(key: String, storage: StorageProtocol, coder: Coder) {
        self.key = key
        self.storage = storage
        self.coder = coder
    }
    
    
    var wrappedValue: Value? {
        get {
            storage.load(with: "", coder: coder)
        }
        set {
            storage.save(value: newValue, for: "", coder: coder)
        }
    }
}


struct LionNSCodingCoder<T: NSCoding & NSObject>: CoderProtocol {
    func encode(_ value: T) throws -> Data {
        try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
    }
    
    func decode(from data: Data) throws -> T {
        guard let ret = try? NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: data) else {
            throw NSError()
        }
        
        return ret
    }
}


class AVFSCache: StorageProtocol {
    var memoryCache = [String: Any]()
    
    func save<Coder>(value: Coder.Value?, for key: String, coder: Coder) where Coder : CoderProtocol {
        memoryCache[key] = value
        
        let data = value.flatMap { try? coder.encode($0) }
        saveToFileCache(data: data)
    }
    
    func load<Coder>(with key: String, coder: Coder) -> Coder.Value? where Coder : CoderProtocol {
        if let value = memoryCache[key] as? Coder.Value {
            return value
        }
        
        let ret = loadFileCache(key: key).flatMap { try? coder.decode(from: $0) }
        memoryCache[key] = ret
        return ret
    }
    
    func saveToFileCache(data: Data?) {
        if let data = data {
            print("save to file \(data.count)")
        } else {
            // remove file cache
        }
    }
    
    func loadFileCache(key: String) -> Data? {
        // read from file cache
        return nil
    }
}

extension UserDefaults: StorageProtocol {
    func save<Coder>(value: Coder.Value?, for key: String, coder: Coder) where Coder : CoderProtocol {
        let data = value.flatMap { try? coder.encode($0) }
        setValue(data, forKey: key)
    }
    
    func load<Coder>(with key: String, coder: Coder) -> Coder.Value? where Coder : CoderProtocol {
        let data = value(forKey: key) as? Data
        let ret = data.flatMap { try? coder.decode(from: $0) }
        return ret
    }
}

class Foo {
    @Storage(key: "", storage: UserDefaults.standard, coder: JsonCoder())
    var name: String?
    
    @Storage(key: "", storage: AVFSCache(), coder: LionNSCodingCoder())
    var son: Person?
    
    @Storage(key: "", storage: AVFSCache(), coder: JsonCoder())
    var girl: Bool?
}

class Person: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        
    }
    
    required init?(coder: NSCoder) {
        
    }
}
