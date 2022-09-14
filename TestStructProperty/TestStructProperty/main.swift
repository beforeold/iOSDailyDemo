//
//  main.swift
//  TestStructProperty
//
//  Created by BrookXy on 2022/4/24.
//

import Foundation

print("Hello, World!")

func foo() {
    class Person {
        struct Book {
            var name: String {
                didSet {
                    print("set name \(name)")
                }
            }
            
            init(name: String) {
                self.name = name
            }
        }
        
        var book: Book {
            set {
                print("set book")
            }
            get {
                print("get book")
                return Book(name: "")
            }
        }
        
        init(book: Book) {
            
        }
    }
    
    let p1 = Person(book: .init(name: "name1"))
//    var b1 = p1.book
//    b1.name = "name2"
//    print(p1.book.name)
    
    p1.book.name = "name3"
}

foo()
