//
//  DownloadImagesView.swift
//  ImageChecker
//
//  Created by Brook_Mobius on 9/14/23.
//

import SwiftUI
import Kingfisher

struct DownloadImagesView: View {
  @State var isLoading = false

  @State var progress: Int = 0
  @State var count: Int = 0

  @State var isDone = false

  var body: some View {
    VStack(spacing: 30) {
      Text("\(progress) / \(count)")

      if isLoading {
        ProgressView()
        Text("Loading")
      } else {
        if isDone {
          Text("🎉 Done!")
        }

        Button("Download All") {
          onDownload()
        }
      }
    }
  }

  private func onDownload() {
    isLoading = true
    Task {
      let items = try await DataLoader.load()
      self.count = items.count

      ImageDownloader.loadItems(
        items
      ) { progress in
        self.progress = progress
      } completion: {
        print("done")
        self.isLoading = false
        self.isDone = true
      }
    }
  }
}

struct DownloadImagesView_Previews: PreviewProvider {
  static var previews: some View {
    DownloadImagesView()
  }
}
