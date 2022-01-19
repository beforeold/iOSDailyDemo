//
//  main.swift
//  TestUserDefaultsPropertyWrapper
//
//  Created by 席萍萍Brook.dinglan on 2021/8/22.
//

import Foundation


import Foundation

public extension UserDefaults {
    /// Retrieves a Codable object from UserDefaults.
    ///
    /// - Parameters:
    ///   - type: Class that conforms to the Codable protocol.
    ///   - key: Identifier of the object.
    ///   - decoder: Custom JSONDecoder instance. Defaults to `JSONDecoder()`.
    /// - Returns: Codable object for key (if exists).
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: Foundation.JSONDecoder = Foundation.JSONDecoder()) -> T? {
        guard let data = value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    
    /// Allows storing of Codable objects to UserDefaults.
    ///
    /// - Parameters:
    ///   - object: Codable object to store.
    ///   - key: Identifier of the object.
    ///   - encoder: Custom JSONEncoder instance. Defaults to `JSONEncoder()`.
    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: Foundation.JSONEncoder = Foundation.JSONEncoder()) {
        let data = try? encoder.encode(object)
        set(data, forKey: key)
    }
}

///
/// https://swiftbysundell.com/articles/property-wrappers-in-swift/
@propertyWrapper
struct UserDefaultsBacked<Value: Codable> {
    private var defaultValue: Value
    private let key: String
    private let userDefaults: UserDefaults
    
    init(wrappedValue defaultValue: Value,
         key: String,
         userDefaults: UserDefaults = .standard)
    {
        self.defaultValue = defaultValue
        self.key = key
        self.userDefaults = userDefaults
    }
    
    var wrappedValue: Value {
        get {
            userDefaults.object(Value.self, with: key) ?? defaultValue
        }
        
        set {
            if let optinal = newValue as? AnyOptional, optinal.isNil {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(object: newValue, forKey: key)
            }
        }
    }
}

extension UserDefaultsBacked where Value: ExpressibleByNilLiteral {
    init(key: String, userDefaults: UserDefaults = .standard) {
        self.init(wrappedValue: nil, key: key, userDefaults: userDefaults)
    }
}


private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}
