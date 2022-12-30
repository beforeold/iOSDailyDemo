//
//  ContentView.swift
//  TestSwiftUIGradient
//
//  Created by Brook_Mobius on 2022/12/30.
//

import SwiftUI

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
    Circle()
      .fill(
        RadialGradient(
          gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple]),
          center: .center,
          startRadius: 50,
          endRadius: 100)
      )
      .frame(width: 200, height: 200)
    
    
  }
}
