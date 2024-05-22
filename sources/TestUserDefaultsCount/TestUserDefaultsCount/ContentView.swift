//
//  ContentView.swift
//  TestUserDefaultsCount
//
//  Created by xipingping on 5/21/24.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("value") var count = 0

  @Storage("value2") var value2 = 0

  @State var showsSheet = false

  var body: some View {
    VStack {
      Button("plus") {
//        self.count += 1
//        if UserDefaults.standard.integer(forKey: "value") == 1 {
//          self.showsSheet = true
//        }

        self.value2 += 1
        if self.value2 == 1 {
          self.showsSheet = true
        }
      }
    }
    .padding()
    .sheet(isPresented: $showsSheet) {
      Text("content of sheet")
    }
  }
}

#Preview {
  ContentView()
}


@propertyWrapper
public struct Storage<T> {

  private let key: String
  private let defaultValue: T

  public init(
    wrappedValue: T,
    _ key: String
  ) {
    self.key = key
    self.defaultValue = wrappedValue
  }

  public var wrappedValue: T {
    get {
      return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }

    nonmutating set {
      if let value = newValue as? OptionalProtocol, value._isNil() {
        UserDefaults.standard.removeObject(forKey: key)
      } else {
        UserDefaults.standard.set(newValue, forKey: key)
      }
    }
  }
}

public extension Storage {
  init(key: String, defaultValue: T) {
    self.init(wrappedValue: defaultValue, key)
  }

  init<RawKey>(
    wrappedValue: T,
    _ key: RawKey
  ) where RawKey: StorageKeyable {
    let string = key.storageKey
    self.init(key: string, defaultValue: wrappedValue)
  }
}

private protocol OptionalProtocol {
  func _isNil() -> Bool
}

extension Optional: OptionalProtocol {
  func _isNil() -> Bool {
    return self == nil
  }
}

public protocol StorageKeyable {
  var storageKey: String { get }
}

public extension UserDefaults {
  /// 可在 app 和 extension 之间共享的数据，后面可以修改为 group container 的实现
  static let shared: UserDefaults = .standard

  /// 存值
  func storeValue<T>(
    _ value: T?,
    forKey key: String
  ) where T: Encodable {
    let data = value.flatMap { ins in
      try? JSONEncoder().encode(ins)
    }
    set(data, forKey: key)
  }

  /// 取值
  func restoreValue<T>(
    forKey key: String
  ) -> T? where T: Decodable {
    let data = value(forKey: key) as? Data
    return data.flatMap { data in
      try? JSONDecoder().decode(T.self, from: data)
    }
  }
}

/// 支持传入 codable 的 wrapper
@propertyWrapper
public struct CodableStorage<T: Codable> {
  private let key: String
  private let defaultValue: T
  private let storage: UserDefaults

  public init(
    wrappedValue: T,
    _ key: String,
    storage: UserDefaults? = nil
  ) {
    self.key = key
    self.defaultValue = wrappedValue
    self.storage = storage ?? .shared
  }

  public var wrappedValue: T {
    get {
      storage.restoreValue(forKey: key) ?? defaultValue
    }

    nonmutating set {
      storage.storeValue(newValue, forKey: key)
    }
  }
}

public extension CodableStorage {
  init<RawKey>(
    wrappedValue: T,
    _ key: RawKey,
    storage: UserDefaults? = nil
  ) where RawKey: StorageKeyable {
    self.init(wrappedValue: wrappedValue, key.storageKey, storage: storage)
  }
}
