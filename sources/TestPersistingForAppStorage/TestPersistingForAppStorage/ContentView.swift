import Combine
import SwiftUI

class Model: ObservableObject {
  @Persisting("count2") var count2 = 0

  @Persisting("gender") var gender: Gender = .unknown

  //  @Persisted(key: "count3") var count3 = 0
}

enum Gender: String, Codable, CaseIterable {
  case unknown
  case male
  case female
}

struct ContentView: View {
  @Persisting("count") var count = 0

  //  @Persisted(key: "count4") var count4 = 0

  @StateObject var model = Model()

  var body: some View {
    VStack(alignment: .leading, spacing: 30) {
      Text("count: \(count)")
      Text("count 2: \(model.count2)")
      //      Text("count 3: \(model.count3)")
      //      Text("count 4: \(count4)")

      Button("Plus") {
        //        count += 1
        model.count2 += 1
        // model.count3 += 1
        // count4 += 1
      }

      slider()

      Divider()

      Text("Gender Value: \(model.gender.rawValue.capitalized)")

      Button("To Female") {
        model.gender = .female
      }

      Picker("Gender", selection: $model.gender) {
        ForEach(Gender.allCases, id: \.self) {
          Text($0.rawValue.capitalized).tag($0)
        }
      }
      .pickerStyle(.segmented)

    }
    .padding()
  }

  func slider() -> some View {
    let value = $model.count2.doubleValue
    return Slider(
      value: value,
      in: 0...100,
      onEditingChanged: { _ in
      }
    )
  }
}

extension Int {
  var doubleValue: Double {
    get {
      Double(self)
    }

    set {
      self = Int(newValue)
    }
  }
}

@MainActor
@propertyWrapper
public struct Persisting<T: Codable & Hashable>: DynamicProperty {
  @AppStorage private var storage: Data
  private let defaultValue: T

  private let encoder: JSONEncoder = .init()
  private let decoder: JSONDecoder = .init()

  /// The wrapped value of the Codable type.
  public var wrappedValue: T {
    get {
      guard let decoded = try? decoder.decode(T.self, from: storage) else {
        return defaultValue
      }
      return decoded
    }

    nonmutating set {
      guard let encoded = try? encoder.encode(newValue) else { return }
      storage = encoded
    }
  }

  public static subscript<Enclosing>(
    _enclosingInstance instance: Enclosing,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, T>,
    storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Self>
  ) -> T where Enclosing: ObservableObject {
    get {
      let storage = instance[keyPath: storageKeyPath]
      return storage.wrappedValue
    }
    set {
      let storage = instance[keyPath: storageKeyPath]
      storage.wrappedValue = newValue

      if let subject = instance.objectWillChange as? ObservableObjectPublisher {
        subject.send()
      }
    }
  }

  /// A binding to the Codable value stored in `UserDefaults`.
  public var projectedValue: Binding<T> {
    Binding(
      get: { wrappedValue },
      set: { wrappedValue = $0 }
    )
  }

  /// Initializes the property wrapper.
  ///
  /// - Parameters:
  ///   - wrappedValue: The default value if no value is found in UserDefaults.
  ///   - key: The key used to store the value in UserDefaults.
  ///   - store: The UserDefaults store to use. Defaults to `.standard`.
  public init(
    wrappedValue: T,
    _ key: String,
    store: UserDefaults? = nil
  ) {
    defaultValue = wrappedValue
    let initialData = (try? encoder.encode(wrappedValue)) ?? Data()
    _storage = .init(wrappedValue: initialData, key, store: store)
  }
}

#Preview {
  ContentView()
}
