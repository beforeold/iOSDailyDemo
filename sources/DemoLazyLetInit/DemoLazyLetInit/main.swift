import Foundation

func createName(from name: String) -> String {
  print(#function, name)

  return "br"
}

class Person {
  static let staticName: String = createName(from: "static")

  let name: String = createName(from: "instance")
}

let person = Person()
print(person)
