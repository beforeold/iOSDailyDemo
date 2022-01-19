//
//  ContentView.swift
//  TestSwiftUIListRender
//
//  Created by 席萍萍Brook.dinglan on 2021/9/5.
//

import SwiftUI

let list = [0, 1, 2, 3, 4, 5, 6, 7]

extension Int: Identifiable {
    public var id: Int {
        self
    }
}

struct ContentView: View {
    var body: some View {
        let button = Button("Tap me") {
            print("tapped")
        }
        
        testSome()
        
        return button
//        List(list) {
//            Text("Hello, world! \($0)")
//                .padding()
//        }
    }
}

struct Builder {
    let flag = true
    
    @ViewBuilder
    var body: some View {
        if flag {
            Text("True")
        } else {
            Text("false")
        }
    }
}


func testSome() {
    let builder = Builder().body
    print(builder)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
