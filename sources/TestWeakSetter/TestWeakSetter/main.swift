//
//  main.swift
//  TestWeakSetter
//
//  Created by Brook_Mobius on 7/10/25.
//

import Foundation

class Book {
  deinit {
    print("brook deinit")
  }
}

class Object {
  weak var book: Book? {
    didSet {
      print("didset", book ?? "null")
    }
  }
}

let object = Object()
object.book = Book()
print("end")

