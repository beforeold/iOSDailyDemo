//
//  ContentView.swift
//  TestFunctionBuilder
//
//  Created by dinglan on 2021/3/12.
//

import SwiftUI

@_functionBuilder
struct StringBuilder {
    static func buildBlock(_ partialResult: String...) -> String {
        "ret: -> \(partialResult)"
    }
}


@StringBuilder var stringValue: String {
    "v1"
    "v2"
    
}

@StringBuilder
func build() -> String {
    "b1"
    "b2"
}

@_functionBuilder
struct ArrayBuilder {
    static func buildBlock<T>(_ items: T...) -> [T] {
        items
    }
}

extension Array {
    init(@ArrayBuilder _ builder: () -> Self) {
        self = builder()
    }
}


struct ContentView: View {
    var text: String {
        Array {
            1
            2
            3
        }.first!.description
    }
    
    var body: some View {
        Text(build())
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
