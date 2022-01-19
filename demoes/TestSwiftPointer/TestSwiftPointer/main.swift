//
//  main.swift
//  TestSwiftPointer
//
//  Created by 席萍萍Brook.dinglan on 2021/9/2.
//

import Foundation

struct Main {
    static func printAddress<T>(node: inout T, _ message: String = "") {
        let addr = address(of: &node)
        print("\(String(describing: message)) addr:\(addr)")
    }

    //打印内存地址
    static func address(of object: UnsafeRawPointer) -> String {
        let addr = Int(bitPattern: object)
        return String(format: "%p", addr)
    }

}

struct Value {
    var pro: Int
    var key1d = 0
    var key2d = 0
    var key3d = 0
    
    var key1a = 0
    var key2a = 0
    var key3a = 0
    var key4a = 0

    var key1b = 0
    var key2b = 0
    var key3b = 0
    var key4b = 0
    
    var key1c = 0
    var key2c = 0
    var key3c = 0
    var key4c = 0
    
    init(value: Int) {
        self.pro = value
    }
}

struct Node {
    var value: Value
    init(value: Value) {
        self.value = value
    }
}

func foo() {
    var a = 5
    var b = a
    Main.printAddress(node: &a, "a")
    Main.printAddress(node: &a, "a")
    Main.printAddress(node: &b, "b")
    print("")
}

func struct1() {
    var v1 = Value(value: 1)
    var v2 = Value(value: 3)
    Main.printAddress(node: &v1, "v1")
    Main.printAddress(node: &v2, "v2")
    print("")
}

func bar() {
    let v1 = Value(value: 5)
    
    var n1 = Node(value: v1)
    var n2 = Node(value: v1)
    Main.printAddress(node: &n1.value.pro, "n1.value")
    Main.printAddress(node: &n2.value.pro, "n1.value")
}

func copy(node: Node) -> Node {
    return node
}

func zoo() {
    let value: Value = .init(value: 1)
    var n1 = Node(value: value)
    
    Main.printAddress(node: &n1, "n1")
    
    var n2 = copy(node: n1)
    var n3 = n1
    
    Main.printAddress(node: &n2, "n2")
    Main.printAddress(node: &n3, "n3")
    Main.printAddress(node: &n1.value.pro, "n1.value")
    Main.printAddress(node: &n2.value.pro, "n2.value")
    Main.printAddress(node: &n3.value.pro, "n3.value")
    print("")
}

func constant() {
    let a1 = Node(value: .init(value: 3))
    let a2 = Node(value: .init(value: 3))
    var a3 = a1
    let b = 5
    print(a1, a2, a3)
}

func array() {
    var a1 = [1, 2, 3, 4]
    var a2 = a1
    Main.printAddress(node: &a1, "a1")
    Main.printAddress(node: &a2, "a2")
    print("")
}

//
//foo()
//struct1()
//zoo()

array()

