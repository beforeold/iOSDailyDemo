//
//  UserStorage.swift
//  ImageChecker
//
//  Created by Brook_Mobius on 9/15/23.
//

import Foundation


/// 支持传入 codable 的 wrapper
@propertyWrapper struct UserStorage<T: Codable> {
  private let key: String
  private let defaultValue: T
  private let storage: UserDefaults

  init(
    wrappedValue: T,
    _ key: String,
    storage: UserDefaults? = nil
  ) {
    self.key = key
    self.defaultValue = wrappedValue
    self.storage = storage ?? .standard
  }

  var wrappedValue: T {
    get {
      // Read value from UserDefaults
      guard let data = storage.object(forKey: key) as? Data else {
        // Return defaultValue when no data in UserDefaults
        return defaultValue
      }

      // Convert data to the desire data type
      let value = try? JSONDecoder().decode(T.self, from: data)
      return value ?? defaultValue
    }

    set {
      // Convert newValue to data
      let data = try? JSONEncoder().encode(newValue)

      // Set value to UserDefaults
      storage.set(data, forKey: key)
    }
  }
}
