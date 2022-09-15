//
//  main.swift
//  TestSwiftSetClass
//
//  Created by BrookXy on 2022/1/7.
//

import Foundation

class MyPerson: NSObject {
//    func foo() {
//
//    }
//
//    func bar() {
//
//    }
    override init() {
        super.init()
        object_setClass(self, Ios15Person.self)
    }
    
    func talk() {
        print("person talk")
    }
    
    class Ios15Person: NSObject {
        func talk() {
            print("mock person talk")
        }
    }
}

class MyClass: NSObject {

    let person: MyPerson
    init(person: MyPerson) {
        self.person = person
        super.init()
        object_setClass(self, Ios15Class.self)
    }

    func foo() {
        
    }
    
    func bar() {
        
    }
    
    func play() {
        print("my play")
    }
    
    class Ios15Class: NSObject {
        let person: MyPerson.Ios15Person
        init(person: MyPerson.Ios15Person) {
            self.person = person
            super.init()
            object_setClass(self, Ios15Class.self)
        }
        
        func play() {
            print("mock play")
        }
    }
}

func foo() -> Any? {
    let ins = MyClass(person: MyPerson())
    ins.play()
    print("end -> \(ins)")
    
    return ins
}

(foo() as? MyClass)?.play()

let ret = foo() as? MyClass
if let ins = ret {
    print("true \(ins)")
} else {
    print("false \(ret as Any)")
}

print(OCClass.isTrue(), "oc")

class OOO: NSObject {
    
}

let cast = foo() as! MyClass
print(cast, "cast")

let cast2 = foo() as! MyClass.Ios15Class
print(cast2, "cast2")

if let f = foo() {
    print(OCClass.oc_isKind(of: MyClass.self, object: f))
    
    print(OCClass.getOf(foo() as Any))
}

foo().flatMap {
    $0 as? MyClass
}?.person.talk()
