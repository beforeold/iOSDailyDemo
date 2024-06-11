//
//  ContentView.swift
//  TestTextEditorSelectionOnly
//
//  Created by xipingping on 6/11/24.
//

import SwiftUI


struct ContentView: View {
  @State private var text: String = "This is a sample text that you can select but not edit."

  var body: some View {
    ZStack {
      TextEditor(text: .constant(text))
//        .disabled(true) // Disable editing
//      Rectangle()
//        .foregroundColor(Color.clear) // Transparent overlay
//        .allowsHitTesting(true) // Intercepts touch events
    }
    .padding()
//    .toolbar(.hidden, for: .)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
