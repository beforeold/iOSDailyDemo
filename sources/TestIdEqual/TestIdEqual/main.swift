//
//  main.swift
//  TestIdEqual
//
//  Created by Brook_Mobius on 7/11/23.
//

import Foundation

// closure 的简化：item.id_equal; item.keypath_equal

struct Person: Identifiable {
  var id: UUID
  var name: String = ""
}

struct Sugar<T> {
  let value: T
  init(_ value: T) {
    self.value = value
  }
  
  func equals<V>(
    by keyPath: KeyPath<T, V>
  ) -> (T) -> Bool
  where V: Equatable {
    return { item in
      item[keyPath: keyPath] == self.value[keyPath: keyPath]
    }
  }
}

/*
extension Sugar {
  func equalTo<Root>(
    _ target: Root
  ) -> (Root) -> Bool
  where Self == KeyPath, Self.Root == Root, Self.Value: Equatable {
    return keyPathEqual(target, self)
  }
}
*/
 
func keyPathEquals<Root, V>(
  _ target: Root,
  _ keyPath: KeyPath<Root, V>
) -> (Root) -> Bool where V: Equatable {
  return { item in
    item[keyPath: keyPath] == target[keyPath: keyPath]
  }
}

extension Identifiable {
  func idEqualTo(_ other: Self) -> Bool {
    return self.id == other.id
  }
}

extension KeyPath where Value: Equatable {
  func equalTo(_ target: Root) -> (Root) -> Bool {
    return keyPathEquals(target, self)
  }
}

func idEqualTo<T>(
  _ target: T
) -> (T) -> Bool
where T: Identifiable {
  return keyPathEquals(target, \.id)
}

extension KeyPath {
  func itself() -> Self {
    return self
  }
}

var personList: [Person] = []

let brook = Person(id: .init())

let _ = Sugar(\Person.id).value.itself()

personList.removeAll { p in
  p.id == brook.id
}

let function = (\Person.id).equalTo(brook)
print(function)

personList.removeAll(where: brook.idEqualTo)
personList.removeAll(where: idEqualTo(brook))
personList.removeAll(where: keyPathEquals(brook, \.id))
personList.removeAll(where: Sugar(brook).equals(by: \.id))
personList.removeAll(where: (\Person.id).equalTo(brook))
personList.removeAll(where: (\Person.name).equalTo(brook))
