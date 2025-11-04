import SwiftUI

struct ContentView: View {
  // 使用 Apple 的测试视频，确保有音频轨道
  private let videoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!

  var body: some View {
    VideoPlayerView(videoURL: videoURL)
      .edgesIgnoringSafeArea(.all)
  }
}

#Preview {
  ContentView()
}
