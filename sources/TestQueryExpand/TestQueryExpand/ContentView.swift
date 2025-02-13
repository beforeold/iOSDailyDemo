import SwiftData
import SwiftUI

@Model
@MainActor
class Person {
  init() {

  }

  var name: String = ""
}

struct MyQuery: DynamicProperty {
  @State private var value: String

  var wrappedValue: String {
    get { value }
    nonmutating set { value = newValue }
  }

  init(wrappedValue: String) {
    self._value = State(wrappedValue: wrappedValue)
  }
}

struct ContentView: View {
  var _query = MyQuery(wrappedValue: "initial")

  @Query var data: [Person]

  func foo() {
    let value: Query<Person, [Person]> = _data
    // @Query macro generate two property data and _data
    print(value)
  }

  var body: some View {
    Button("tap") {
      _query.wrappedValue = "changed"
    }

    Text("name: \(_query.wrappedValue)")

  }
}

#Preview {
  ContentView()
}
