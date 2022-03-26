//
//  main.swift
//  TestEncodableArrayArgument
//
//  Created by BrookXy on 2022/3/23.
//

import Foundation

print("Hello, World!")

protocol ToDatable {
    func toData() -> Data
}

extension Encodable {
    func toData() {
        
    }
}


/*
func call4(_ method: String, arguments: [Encodable]) {
    let encoder = JSONEncoder()
    arguments.flatMap {
        let data = try? encoder.encode($0)
    }
//    let data = try! encoder.encode(arguments)
//    print(data as Any)
}
*/


func call3<Arg: Encodable>(_ method: String, arguments: [Arg]) {
    let encoder = JSONEncoder()
    let dataArray = arguments.map { item -> Data in
        let data = try! encoder.encode(item)
        return data
    }
    print(dataArray as Any)
}

@resultBuilder
struct DataBuilder {
    static func buildBlock(_ components: Data?...) -> Data {
        return components.reduce(Data()) { partialResult, data in
            return partialResult + (data ?? Data())
        }
    }
}


func call5(_ method: String,
           @DataBuilder arguments: (JSONEncoder) -> Data) {
    let encoder = JSONEncoder()
    let data = arguments(encoder)
    print(data as Any)
}

call5("echo") { encoder in
    try? encoder.encode(123)
    try? encoder.encode("ok")
}



@resultBuilder
struct DataBuilder2 {
    static func buildBlock<T: Encodable>(_ components: T) -> Data {
        return try! JSONEncoder().encode(components)
    }
}


func call6(_ method: String,
           @DataBuilder2 arguments: (JSONEncoder) -> Data) {
    let encoder = JSONEncoder()
    let data = arguments(encoder)
    print(data as Any)
}

call6("eco") { encoder in
    5
}

func call7<E1, E2, E3>(_ method: String,
                       _ e1: E1? = nil,
                       _ e2: E2? = nil,
                       _ e3: E3? = nil) where E1: Encodable, E2: Encodable, E3: Encodable {
    
}

call7("echo", 123, "arg", Data())


func call8(_ method: String, _ args: Encodable...) {
    struct WrapEncodable: Encodable {
        let wrapped: Encodable
        
        func encode(to encoder: Encoder) throws {
            try wrapped.encode(to: encoder)
        }
    }
    
    let wrappedList = args.map { WrapEncodable(wrapped: $0) }
    let data = try? JSONEncoder().encode(wrappedList)
    print(data as Any)
}
