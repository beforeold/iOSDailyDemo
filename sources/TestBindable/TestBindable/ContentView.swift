//
//  ContentView.swift
//  TestBindable
//
//  Created by xipingping on 5/23/24.
//

import SwiftUI
import Observation

@Observable final class Model {
    var age = 0
}

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

#Preview {
    ContentView()
}
