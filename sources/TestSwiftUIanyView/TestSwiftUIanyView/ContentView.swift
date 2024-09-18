//
//  ContentView.swift
//  TestSwiftUIanyView
//
//  Created by beforeold on 6/13/24.
//

import SwiftUI

func __b_buildView(@SwiftUI.ViewBuilder body: () -> any SwiftUI.View) -> any SwiftUI.View {
    body()
}

struct LoadingView: View {
  @ViewBuilder var progressView: () -> any View
  
  var body: some View {
    VStack {
      Text("loading")
      
      AnyView(self.progressView())
    }
  }
}

struct ViewFunction {
  func takeView<V>(_ view: V) where V: View {
    
  }
  
  func takeAnyView(_ view: any View) {
    
  }
}

func foo() {
  let view = __b_buildView {
    Text("hello")
  }
  
  ViewFunction().takeView(view)
  ViewFunction().takeAnyView(view)
}

struct ContentView: View {
  var body: some View {
    LoadingView {
      ProgressView()
      ProgressView()
    }
    .padding()
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
