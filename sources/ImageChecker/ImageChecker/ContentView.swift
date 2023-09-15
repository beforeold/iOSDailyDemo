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
    VStack(spacing: 30) {
      Button("Download") {
        showsDownloadView = true
      }

      Button("Test") {
        onTest()
      }
    }
    .padding()
    .sheet(isPresented: $showsDownloadView) {
      DownloadImagesView()
    }
    .onAppear {
      onTest()
    }
  }

  private func onTest() {
    Task {
      do {
        let items = try await DataLoader.load()
        let checkItems = Array(items.prefix(1000))
        let tester = FaceImageTester(items: checkItems)
        try await tester.testFace()
      } catch {
        debugPrint(#function, error)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
