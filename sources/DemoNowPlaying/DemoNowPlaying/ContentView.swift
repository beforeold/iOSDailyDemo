import MediaPlayer
import SwiftUI

struct ContentView: View {
  @State private var info = ""
  @State private var artwork: UIImage? = nil

  var body: some View {
    VStack(spacing: 30) {
      if let artwork = artwork {
        Image(uiImage: artwork)
          .resizable()
          .frame(width: 100, height: 100)
      }
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
      artwork = nil
      return
    }
    info = ""

    info += "albumArtist: \(item.albumArtist ?? "null")\n"
    info += "artist: \(item.artist ?? "null")\n"
    info += "title: \(item.title ?? "null")\n"
    info += "albumTitle: \(item.albumTitle ?? "null")\n"

    let artworkImage = item.artwork?.image(at: CGSize(width: 100, height: 100))
    artwork = artworkImage
  }
}

#Preview {
  ContentView()
}
