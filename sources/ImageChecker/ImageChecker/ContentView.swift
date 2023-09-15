//
//  ContentView.swift
//  ImageChecker
//
//  Created by Brook_Mobius on 9/14/23.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var tester = FaceImageTester()

  @State var showsDownloadView = false

  @State var showsLabel = false

  var body: some View {
    VStack(spacing: 30) {
      Button("Download") {
        showsDownloadView = true
      }

      Button("Label") {
        showsLabel = true
      }

      Button("Test") {
        testAll()
      }
    }
    .padding()
    .sheet(isPresented: $showsDownloadView) {
      DownloadImagesView()
    }
    .sheet(isPresented: $showsLabel) {
      if let selected = tester.selectedInfo {
        LabelPicker(
          tester: tester
        ) { isForward in
          tester.handle(isForward: isForward, selected: selected)
        } picker: { flag_ in
          FaceImageTester.updateFront(flag: flag_, url: selected.item.url)
        }

      } else {
        Text("not selected")
      }
    }
  }

  private func testAll() {
    Task {
      do {
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
