//
//  ContentView.swift
//  DemoYoutubeView
//
//  Created by beforeold on 3/16/26.
//

import SwiftUI

struct ContentView: View {
  var url: URL? {
    URL(string: "https://www.youtube.com/embed/lj8lwuiG_hg?playsinline=1")
  }
  var body: some View {
    WebView(url: url)
      .frame(height: 300)
      .ignoresSafeArea()
  }
}

#Preview {
  ContentView()
}
