import ImagePlayground
import SwiftUI

struct ContentView: View {
  @State private var url: URL?
  @State private var isPresented = false
  @State private var prompt = ""

  var body: some View {
    VStack(spacing: 30) {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")

      TextEditor(text: $prompt)
        .frame(width: 300, height: 120)
        .border(Color.blue)

      if let url {
        let _ = print("render url", url.lastPathComponent)
        LocalImageView(localURL: url)
          .id(url)
      }

      Button("Create") {
        isPresented = true
      }
    }
    .padding()
    .imagePlaygroundSheet(isPresented: $isPresented, concept: prompt) { url in
      print(url)
      self.url = url
    }
  }
}

import SwiftUI

struct LocalImageView: View {
  let localURL: URL

  @State private var image: Image? = nil

  var body: some View {
    Group {
      if let image = image {
        image
          .resizable()
          .scaledToFit()
      } else {
        ProgressView() // Loading placeholder
      }
    }
    .onAppear {
      loadImage(from: localURL)
    }
  }

  private func loadImage(from url: URL) {
    DispatchQueue.global(qos: .background).async {
      if let data = try? Data(contentsOf: url),
         let uiImage = platformImage(data: data) {
        DispatchQueue.main.async {
          self.image = Image(uiImage: uiImage)
        }
      }
    }
  }

  private func platformImage(data: Data) -> UIImage? {
#if os(macOS)
    if let nsImage = NSImage(data: data) {
      return UIImage(cgImage: nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
    }
    return nil
#elseif os(iOS) || os(tvOS) || os(watchOS)
    return UIImage(data: data)
#endif
  }
}


#Preview {
  ContentView()
}
