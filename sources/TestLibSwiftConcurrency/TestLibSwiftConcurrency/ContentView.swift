//
//  ContentView.swift
//  TestLibSwiftConcurrency
//
//  Created by Brook_Mobius on 4/28/23.
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
    .onAppear {
      // call this method will embem libSwift_concurrency.dylib into ipa Frameworks
      self.foo()
    }
  }
  
  @MainActor
  func foo() {
    Task {
      await bar()
    }
  }
  
  func bar() async {
    print("bar")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
