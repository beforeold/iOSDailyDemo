import SwiftUI

@propertyWrapper
struct MyState: DynamicProperty {
  var wrappedValue: String {
    get { value }
    nonmutating set { value = newValue }
  }

  @State private var value: String

  init(wrappedValue: String) {
    self._value = State(wrappedValue: wrappedValue)

  }

  //  func update() {
  //    print(#function)
  //  }
}

@propertyWrapper
struct Network: DynamicProperty {
  @State private var list: [String] = []

  var wrappedValue: [String] {
    list
  }

  func update() {
    if list.isEmpty {
      Task {
        list = ["H"]
      }
    }
  }
}

@propertyWrapper
struct MyState2: DynamicProperty {
  var wrappedValue: String {
    get { UserDefaults.standard.string(forKey: "name2") ?? "initial" }
    nonmutating set { UserDefaults.standard.set(newValue, forKey: "name2") }
  }

  func update() {
    print(#function)
  }
}

struct ContentView: View {
  @Network var list

  @MyState private var name = "initial"
  @MyState2 private var name2

  var body: some View {
    VStack(spacing: 30) {
      //      Text("name: \(name)!")
      Text("name2: \(name2)!")
    }
    .padding()
    .onTapGesture {
      //      name = "changed"
      name2 += "changed"
    }
  }
}

#Preview {
  ContentView()
}

func performOperations(a: Int, b: Int, add: (Int, Int) -> Int, multiply: (Int, Int) -> Int) {
  let sum = add(a, b)
  let product = multiply(a, b)
  print("Sum: \(sum), Product: \(product)")
}

func foo() {
  performOperations(a: 1, b: 2) { a, b in
    a + b
  } multiply: { x, y in
    x * y
  }

  performOperations(
    a: 1,
    b: 2,
    add: { a, b in
      a + b
    },
    multiply: { x, y in
      x * y
    }
  )

  performOperations(
    a: 1,
    b: 2,
    add: { a, b in
      a + b
    }
  ) { x, y in
    x * y
  }

}

//
//func bar() {
//  performOperations(a: 3, b: 5, add: { <#Int#>, <#Int#> in
//    <#code#>
//  }, int: 5
//  ) { <#Int#>, <#Int#> in
//    <#code#>
//  }
//}
