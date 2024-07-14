//
//  ContentView.swift
//  TestIOSColor
//
//  Created by beforeold on 7/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Primary Color Example
            Text("Primary Color")
                .foregroundColor(Color.primary)
                .padding()
                .background(Color.primary/*.opacity(0.1)*/)
                .cornerRadius(8)

            // Secondary Color Example
            Text("Secondary Color")
                .foregroundColor(Color.secondary)
                .padding()
                .background(Color.secondary/*.opacity(0.1)*/)
                .cornerRadius(8)

            // Tertiary Color Example
            Text("Tertiary Color")
                .foregroundColor(Color(.tertiaryLabel))
                .padding()
                .background(Color.indigo)
                .cornerRadius(8)

            // Quaternary Color Example
            Text("Quaternary Color")
                .foregroundColor(Color(.quaternaryLabel))
                .padding()
                .background(Color(.quaternarySystemFill))
                .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
