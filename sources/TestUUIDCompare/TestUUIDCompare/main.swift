//
//  main.swift
//  TestUUIDCompare
//
//  Created by Brook_Mobius on 2023/4/10.
//

import Foundation

struct Person {
  let id: UUID
  let age: Int
}


let people: [Person] = (0..<10).map {
  Person(id: UUID(), age: $0)
}

let sorted = people.sorted {
  let result = ($0.id as NSUUID).compare($1.id)
  
  switch result {
  case .orderedSame:
    return true
    
  case .orderedAscending:
    return true
    
  case .orderedDescending:
    return false
  }
}

print("sorted by id, result age: ", sorted.map(\.age))
