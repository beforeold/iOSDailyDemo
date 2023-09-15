//
//  ContentView.swift
//  ImageChecker
//
//  Created by Brook_Mobius on 9/14/23.
//

import SwiftUI

struct ContentView: View {
  @State var showsDownloadView = false

  var body: some View {
    VStack {
      Button("Download") {
        showsDownloadView = true
      }
    }
    .padding()
    .sheet(isPresented: $showsDownloadView) {
      DownloadImagesView()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
