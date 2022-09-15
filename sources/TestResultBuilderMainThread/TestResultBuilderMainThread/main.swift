//
//  main.swift
//  TestResultBuilderMainThread
//
//  Created by BrookXy on 2022/1/17.
//

import Foundation
import SwiftUI


// MARK: - resultBuilder demo
@resultBuilder
struct Sum {
    static func buildBlock(_ components: Int...) -> Int {
        return components.reduce(0, +)
    }
}

func zoo(@Sum _ handler: () -> Int) {
    let ret = handler()
    print("zoo \(ret)")
}

func plusOne(_ int: Int) -> Int {
    return int + 1
}

zoo {
    plusOne(1)
    plusOne(1)
    5
}

// MARK: - resultBuilder main thread

typealias Handler = ()

@resultBuilder
struct MainThread {
    static func buildBlock(_ components: Handler) -> Handler {
        return components
    }
}


func bar(@MainThread _ handler: () -> Void) {
    
}

bar {
    someFunc()
}

// MARK: - property wrapper main thread

@propertyWrapper
struct MainWay<T> {
    public  init(wrappedValue: @escaping (T) -> Void) {
        self.wrappedValue = { int in
            DispatchQueue.global().async {
                print("main thread")
                wrappedValue(int)
            }
        }
    }

    public var wrappedValue: (T) -> Void
}

@propertyWrapper
public struct MainWayBlock {
    public init(wrappedValue: @escaping () -> Void) {
        self.wrappedValue = {
            // mock main thread with global queue
            DispatchQueue.global().async {
                print("main thread")
                wrappedValue()
            }
        }
    }

    public var wrappedValue: () -> Void
}

func mainwayNoArg(@MainWayBlock _ arg: @escaping () -> Void) {
    arg()
}

public func mainwayWithArg(@MainWay _ arg: @escaping (Int) -> Void) {
    arg(666)
}




mainwayNoArg {
    print("my work")
}

mainwayWithArg {
    print("my work -> \($0)")
}

sleep(3)

public class Person {
    @MainWayBlock
    public var handler: () -> Void = {}
}
