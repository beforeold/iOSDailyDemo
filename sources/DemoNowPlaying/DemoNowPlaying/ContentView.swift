import MediaPlayer
import SwiftUI

struct ContentView: View {
  @State private var info = ""

  var body: some View {
    VStack(spacing: 30) {
      Text(info)

      Button("Get", action: getItem)
    }
    .padding()
    .onAppear {
      getItem()
    }
  }

  private func getItem() {
    // print(MPNowPlayingInfoCenter.default().nowPlayingInfo ?? "null")

    guard let item = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem else {
      info = "null music item"
      return
    }
    info = ""

    info += "albumArtist: \(item.albumArtist ?? "null")\n"
    info += "artist: \(item.artist ?? "null")\n"
    info += "title: \(item.title ?? "null")\n"
    info += "albumTitle: \(item.albumTitle ?? "null")\n"
  }
}

#Preview {
  ContentView()
}
