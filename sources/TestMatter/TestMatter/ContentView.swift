//
//  ContentView.swift
//  TestMatter
//
//  Created by beforeold on 2022/12/9.
//

import SwiftUI

import Matter
import MatterSupport


struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
