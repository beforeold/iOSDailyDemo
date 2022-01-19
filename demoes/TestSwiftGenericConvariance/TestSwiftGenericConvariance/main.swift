//
//  main.swift
//  TestSwiftGenericConvariance
//
//  Created by 席萍萍Brook.dinglan on 2021/12/16.
//

import Foundation

class Person { }

struct Wrap<T: Person> {
    var base: T?
}

class Student: Person { }

func call(_ arg: Wrap<Person>) {
}

func foo() {
    let studentWrap = Wrap<Student>()
    call(studentWrap)
}

foo()
