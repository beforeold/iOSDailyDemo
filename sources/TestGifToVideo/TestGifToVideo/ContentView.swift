import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Button {
        foo()
      } label: {
        Text("start")
      }

    }
    .padding()
  }
}


func foo() {
  // Usage example:
  guard let gifUrl = Bundle.main.url(forResource: "test", withExtension: "GIF") else {
    print("test.gif not found")
    return
  }
  let outputUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test.mp4")
  convertGifToVideo(gifUrl: gifUrl, outputUrl: outputUrl) { result in
    switch result {
    case .success(let url):
      print("Video saved to \(url)")
    case .failure(let error):
      print("Error: \(error.localizedDescription)")
    }
  }

}


#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
