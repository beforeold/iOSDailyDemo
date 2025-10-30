//
//  ContentView.swift
//  DemoDocumentpp
//
//  Created by beforeold on 2025/10/28.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: DemoDocumentppDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(DemoDocumentppDocument()))
}
