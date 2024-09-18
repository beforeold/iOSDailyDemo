//
//  ContentView.swift
//  TestHello
//
//  Created by beforeold on 6/13/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

func foo() {
  Swift.print("Hello, world!")
}

#Preview {
    ContentView()
}
