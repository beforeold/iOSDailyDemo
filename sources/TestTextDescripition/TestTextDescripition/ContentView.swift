import SwiftUI

enum Test: String, CustomStringConvertible {
  var description: String { rawValue }

  case ok
}

enum Test2 {
  case failed
}

struct Person: Equatable {
  var name = "bo"
}

struct PersonFormat: FormatStyle {
  func format(_ value: Person) -> String {
    value.name
  }
}

struct ContentView: View {
  var body: some View {
    VStack(spacing: 30) {
      Text("\(Test.ok)")
      Text("\(Test2.failed)")
      Text("\(Person())")
      Text(5, format: .number)
      Text(Person(name: "Lily"), format: PersonFormat())
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
