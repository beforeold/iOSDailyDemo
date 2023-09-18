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
      HStack {
        Button("打标") {
          showsLabel = true
        }

        Button("打印") {
          tester.showInfo()
        }
      }

      Button("检测") {
        testAll()
      }

      Button("下载") {
        showsDownloadView = true
      }
    }
    .frame(maxHeight: .infinity, alignment: .bottom)
    .buttonStyle(.borderedProminent)
    .padding()
    .sheet(isPresented: $showsDownloadView) {
      DownloadImagesView()
    }
    .fullScreenCover(isPresented: $showsLabel) {
      if let selected = tester.selectedInfo {
        LabelPicker(
          tester: tester
        ) { isForward in
          tester.handle(isForward: isForward, selected: selected)
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
