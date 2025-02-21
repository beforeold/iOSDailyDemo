import Cocoa
import SwiftSoup
import SwiftUI

#if canImport(Appkit)
  import AppKit
#endif

struct ContentView: View {
  var body: some View {
    VStack {
      Button("Read") {
        readPasteborad()
      }
    }
    .padding()
    .onAppear {
      readPasteborad()
    }
  }

  func readPasteborad() {
    #if os(macOS)
      //      func retrieveImageFromClipboard() -> NSImage? {
      //        let pasteboard = NSPasteboard.general
      //        let types = pasteboard.types ?? []
      //        print("types", types)
      //
      //        for type in types {
      //          if let data = pasteboard.data(forType: type) {
      //            return NSImage(data: data)
      //          }
      //        }
      //        return nil
      //      }
      //
      //      let image = retrieveImageFromClipboard()
      // print(image?.description ?? "null")
      Task {
        let data = await retrieveImageFromHTMLClipboard()
        let image = data.flatMap { NSImage(data: $0) }
        print(image?.description ?? "null")
      }
    #endif
  }

}

func retrieveImageFromHTMLClipboard() async -> Data? {
  let pasteboard = NSPasteboard.general
  if let types = pasteboard.types, types.contains(.html) {
    // Get the HTML content from the pasteboard
    if let htmlData = pasteboard.data(forType: .html),
      let htmlString = String(data: htmlData, encoding: .utf8)
    {
      // Parse the HTML using SwiftSoup
      print("html", htmlString, "\n")

      do {
        let document = try SwiftSoup.parse(htmlString)
        let imageUrl = try document.select("img").attr("src")
        // If there is an image URL, download it
        if let url = URL(string: imageUrl) {
          print("url", url, "\n")
          if let imageData = await downloadImageData(from: url) {
            return imageData
          }
        }
      } catch {
        print("Error parsing HTML: \(error)")
      }
    }
  }
  return nil
}


// Async function to fetch image data from URL
func downloadImageData(from url: URL) async -> Data? {
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    } catch {
        print("Error fetching image data: \(error)")
        return nil
    }
}

#Preview {
  ContentView()
}
