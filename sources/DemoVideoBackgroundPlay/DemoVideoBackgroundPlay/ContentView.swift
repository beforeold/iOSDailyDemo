import SwiftUI

struct ContentView: View {
  // 使用 Apple 的测试视频，确保有音频轨道
  private let videoURL = URL(string: "https://samplelib.com/lib/preview/mp4/sample-5s.mp4")!
  // private let videoURL = URL(string: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4")!
  // private let videoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!
  // private let videoURL = URL(string: "https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4")!
  // private let videoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!

  var body: some View {
    VideoPlayerView(videoURL: videoURL)
      .edgesIgnoringSafeArea(.all)
  }
}

#Preview {
  ContentView()
}
