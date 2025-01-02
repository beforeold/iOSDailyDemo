import Kingfisher
import SwiftUI

struct ContentView: View {
  var body: some View {
    ScrollView {
      ForEach(0..<1) { _ in
        KFImage(URL(string: "https://file.guangshaxx.com/detail/2f20eae35be594a963624b7849b8e8eb.jpeg"))
          .setProcessor(DownsamplingImageProcessor(size: .init(width: 50, height: 50)))
//        KFImage(URL(string: "https://file.guangshaxx.com/detail/2f20eae35be594a963624b7849b8e8eb.jpeg"))
      }
    }
    .padding()
    .onAppear {
      print("on appear")
    }
  }
}

#Preview {
  ContentView()
}
