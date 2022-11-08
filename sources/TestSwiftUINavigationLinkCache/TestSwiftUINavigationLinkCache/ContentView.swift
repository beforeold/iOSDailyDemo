//
//  ContentView.swift
//  TestSwiftUINavigationLinkCache
//
//  Created by Brook_Mobius on 2022/11/8.
//

import SwiftUI

struct LandingView: View {
  init() {
    print("LandingView init")
  }
  var body: some View {
    VStack {
      Image(systemName: "photo")
        .imageScale(.large)
      Text("Landing Page")
    }
    .foregroundColor(.orange)
    .padding()
  }
}


struct ContentView: View {
  var body: some View {
    NavigationLink {
      // 重复进入 LandingView 居然是缓存的，不会重复构造 LandingView()
      LandingView()
    } label: {
      VStack {
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundColor(.accentColor)
        Text("Tap to landing")
      }
      .padding()
    }
    
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
