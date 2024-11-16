import Foundation

do {

  let array: [String] = Person().getArray()
  print(type(of: array[0]), array[0])

  let mutable = Person().getMutableArray()
  let value = mutable[0]
  print(type(of: value), value)
}

do {
  let container = Container(value: Person())
  let person = container.value
  print(type(of: person.array[0]), person.array[0])
  print(type(of: person.mutableArray[0]), person.mutableArray[0])

}
