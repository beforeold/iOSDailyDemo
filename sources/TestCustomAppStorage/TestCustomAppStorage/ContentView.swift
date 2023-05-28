//
//  ContentView.swift
//  TestCustomAppStorage
//
//  Created by Brook_Mobius on 5/24/23.
//

import SwiftUI
import Combine

@propertyWrapper
struct MyAppStorage<Value>: DynamicProperty {
  @State private var storedValue: Value
  private let key: String
  
  var wrappedValue: Value {
    get {
      storedValue
    }
    nonmutating set {
      storedValue = newValue
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
  
  init(wrappedValue defaultValue: Value, _ key: String) {
    self._storedValue = State(initialValue: UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue)
    self.key = key
    UserDefaults.standard.register(defaults: [key: defaultValue])
  }
  
  var projectedValue: Binding<Value> {
    Binding(
      get: { self.wrappedValue },
      set: { self.wrappedValue = $0 }
    )
  }
}

@propertyWrapper
public class MainThreadPublished<Value> {
  @Published
  private var value: Value
  
  public var projectedValue: Published<Value>.Publisher {
    get {
      assert(Thread.isMainThread, "Accessing @MainThread property on wrong thread: \(Thread.current)")
      return $value
    }
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    set {
      assert(Thread.isMainThread, "Accessing @MainThread property on wrong thread: \(Thread.current)")
      $value = newValue
    }
  }
  
  public var wrappedValue: Value {
    get {
      assert(Thread.isMainThread, "Accessing @MainThread property on wrong thread: \(Thread.current)")
      return value
    }
    set {
      assert(Thread.isMainThread, "Accessing @MainThread property on wrong thread: \(Thread.current)")
      value = newValue
    }
  }
  
  public init(wrappedValue value: Value) {
    self.value = value
  }
  
  public init(initialValue value: Value) {
    self.value = value
  }
}

//@propertyWrapper
//class CustomPublished<Value>: DynamicProperty {
//    @Published private var value: Value
//
//    var wrappedValue: Value {
//        get { value }
//        set { value = newValue }
//    }
//
//    var projectedValue: Published<Value>.Publisher {
//        $value
//    }
//
//    init(wrappedValue: Value) {
//        self.value = wrappedValue
//    }
//}

//
//@propertyWrapper
//class CustomPublished<Value> {
//    private var value: Value
//    private var cancellables = Set<AnyCancellable>()
//    private var publisher = PassthroughSubject<Value, Never>()
//
//    var wrappedValue: Value {
//        get { value }
//        set {
//            value = newValue
//            publisher.send(newValue)
//        }
//    }
//
//    var projectedValue: AnyPublisher<Value, Never> {
//        publisher.eraseToAnyPublisher()
//    }
//
//    init(wrappedValue: Value) {
//        value = wrappedValue
//
//        publisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
//                self?.objectWillChange.send()
//            }
//            .store(in: &cancellables)
//    }
//}


class ViewModel: ObservableObject {
  // @Published @MyAppStorage("ageKey2") var age2: Int = 5
  @MainThreadPublished var age2 = 5
  
  @Published var age4 = 5
  
  @Published var age3 = 5
  
  init() {
    print(self)
    var value_age3 = self._age3
    let value_age3_3 = value_age3
    let pub = value_age3.projectedValue
    print(value_age3, value_age3_3, pub)
    
    let mirror = Mirror(reflecting: self)
    mirror.children.forEach { child in
      debugPrint("child", child)
      //                if let observedProperty = child.value as? PublishedWrapper {
      //                    observedProperty.objectWillChange = self.objectWillChange
      //                }
    }
  }
}

struct ContentView: View {
  @AppStorage("aa") var name: String = ""
  
  @MyAppStorage("ageKey") var age: Int = 5
  
  @StateObject var viewModel: ViewModel = ViewModel()
  
  var body: some View {
    VStack(spacing: 20) {
      
      Text("age1: \(age)")
        .onTapGesture {
          age += 7
        }
      
      Text("age2: \(viewModel.age2)")
        .onTapGesture {
          viewModel.age2 += 7
        }
      
      Text("age4: \(viewModel.age4)")
        .onTapGesture {
          print("tap age4")
          viewModel.age4 += 7
        }
      
      Text("age5: \(viewModel.age5)")
        .onTapGesture {
          print("tap age4")
          viewModel.age4 += 7
        }
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
