import SwiftUI

struct ContentView: View {
  @State private var id = 0

  var body: some View {
    VStack {
      InnerView()

      Button("update") {
        id += 1
      }
      .id(id)
    }
    .padding()
  }
}

struct Value {
  var age: Int

  init(age: Int) {
    print("init value")
    self.age = age
  }
}

@Observable
class StateValue {
  init() {
    print("init StateValue")
  }

  var name = ""

  var flag = false
}

struct InnerView: View {
  @State private var value: Value = .init(age: 8)
  @StateRef private var stateValue: StateValue = .init()

  init() {
    print("init InnerView")
    //    _value = State(initialValue: .init(age: 8))
    //    _stateValue = StateObject(wrappedValue: StateValue())
  }

  var body: some View {
    let _ = print("inner body")

    HStack {
      let value = $stateValue
      Toggle(isOn: value.flag) {
        Text("Toggle")
      }

      Text("inner: \(stateValue.name)")

      Button("name it") {
        stateValue.name = "br"
      }
    }
  }
}

@propertyWrapper @MainActor

struct StateRef<Value: AnyObject & Observable>: DynamicProperty {
  @StateObject private var container = ValueContainer<Value>()
  let makeValue: () -> Value

  init(wrappedValue: @autoclosure @escaping () -> Value) {
    self.makeValue = wrappedValue
  }

  var wrappedValue: Value {
    container.value ?? makeValue()
  }

//  var projectedValue: Binding<Value> {
//    $container.value
//  }

  var projectedValue: Bindable<Value> {
    Bindable(wrappedValue)
  }

  nonisolated func update() {
    MainActor.assumeIsolated {
      if container.value == nil {
        print("update hit")
        container.value = makeValue()
      }
    }
  }
}

private final class ValueContainer<Value: Observable>: ObservableObject {
  // No need to make it @Published because Value is Observable.
  var value: Value!
}

#Preview {
  ContentView()
}
