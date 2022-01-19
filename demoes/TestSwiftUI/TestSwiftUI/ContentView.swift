//
//  ContentView.swift
//  TestSwiftUI
//
//  Created by dinglan on 2021/3/16.
//

import SwiftUI

struct ContentView: View {
    func text() -> String {
        "swiftui is great!" + "__h__h" + "😸\n\n\n" + abc()
    }
    
    func abc() -> String {
        return "abc"
    }
    
    var body: some View {
        let v = HStack {
            Text(text())
                .padding().font(.largeTitle)
            Text(text())
                .padding()
            if true {
                Text(text())
                    .padding()
            } else {
                if true {
                    Text(text())
                        .padding()
                }
            }
        }
        // v: generic type
        return v
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
    
    func foo() {
        let aa = ContentView()
    }
}
