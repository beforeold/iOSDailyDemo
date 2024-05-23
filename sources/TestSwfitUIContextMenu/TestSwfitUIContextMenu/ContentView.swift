//
//  ContentView.swift
//  TestSwfitUIContextMenu
//
//  Created by xipingping on 5/17/24.
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
        .contextMenu {
            Button("menu") { }
                .offset(.init(width: 10000, height: 10000))
                .background(Color.blue)
            Menu {
                Text("content")
                    .opacity(0)
            } label: {
                Text("label")
                    .opacity(0)
            }

        } preview: {
            Text("previewing")
                .frame(width: 200, height: 200)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
