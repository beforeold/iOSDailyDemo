import Foundation


struct Book: CustomStringConvertible, CustomDebugStringConvertible {
  var name: String

  var description: String {
    name
  }

  var debugDescription: String {
    "debug: \(name)"
  }
}

@DebugDescription
struct Person {
  var name: String
  var books: [Book] = []
}

let person = Person(name: "br")
print(person)
