//
//  main.swift
//  TestAsyncCompletion
//
//  Created by BrookXy on 2022/6/2.
//

import Foundation

print("Hello, World! 1")

func foo() async {
    print("foo async")
}


// await foo()
//

func taskFoo() {
    Task {
        await foo()
    }
}

taskFoo()

for _ in 0..<1_0000_0000 {
    print("")
}

print("Hello, World! 2")

//
//foo {
//    print("over")
//}
