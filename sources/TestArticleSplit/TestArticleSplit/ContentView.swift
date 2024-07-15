import SwiftUI
import SwiftUI

struct Content: Hashable {
  var text: String
}

struct ContentView: View {


  @State private var currentPage = 0

  var body: some View {
    let slides = splitArticle(article, chunkSize: 100)

    VStack {
      Text(slides[currentPage])
        .padding()
        .animation(.easeInOut, value: currentPage)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

      HStack {
        Button(action: {
          if currentPage > 0 {
            currentPage -= 1
          }
        }) {
          Text("Previous")
        }
        .padding()
        .disabled(currentPage == 0)

        Spacer()

        Button(action: {
          if currentPage < slides.count - 1 {
            currentPage += 1
          }
        }) {
          Text("Next")
        }
        .padding()
        .disabled(currentPage == slides.count - 1)
      }
    }
    //    .padding()
    .frame(idealHeight: 240)
    .background(Color.black)
    .preferredColorScheme(.dark)
  }

  func splitArticle(_ text: String, chunkSize: Int) -> [String] {
    var chunks: [String] = []
    var currentIndex = text.startIndex

    while currentIndex < text.endIndex {
      let endIndex = text.index(currentIndex, offsetBy: chunkSize, limitedBy: text.endIndex) ?? text.endIndex
      let chunk = text[currentIndex..<endIndex]
      chunks.append(String(chunk))
      currentIndex = endIndex
    }

    return chunks
  }
}


struct ContentView2: View {
  @ObservedObject var appViewModel: AppViewModel
  var content: Content

  @State private var currentPage = 0

  var body: some View {
    let slides = splitArticle(content.text, chunkSize: 100)

    VStack(alignment: .leading) {
      Text(slides[currentPage])
        .font(.title2)
        .padding()
        .animation(.easeInOut, value: currentPage)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

      HStack {
        Button(action: {
          if currentPage > 0 {
            currentPage -= 1
          }
        }) {
          Text("Previous")
        }
        .padding()
        .disabled(currentPage == 0)

        Spacer()

        Button(action: {
          if currentPage < slides.count - 1 {
            currentPage += 1
          }
        }) {
          Text("Next")
        }
        .padding()
        .disabled(currentPage == slides.count - 1)
      }
    }
    .padding()
    .frame(idealHeight: 240)
    .background(Color.black)
    .preferredColorScheme(.dark)
  }

  func splitArticle(_ text: String, chunkSize: Int) -> [String] {
    let paragraphs = text.components(separatedBy: "\n")
    var chunks: [String] = []
    var currentChunk = ""

    for paragraph in paragraphs {
      if currentChunk.count + paragraph.count + 2 <= chunkSize {
        if !currentChunk.isEmpty {
          currentChunk += "\n"
        }
        currentChunk += paragraph
      } else {
        if !currentChunk.isEmpty {
          chunks.append(currentChunk)
        }
        currentChunk = paragraph
      }
    }

    if !currentChunk.isEmpty {
      chunks.append(currentChunk)
    }

    return chunks
  }
}


let article: String = """
Apple is committed to making sure that the App Store is a safe place for everyone — especially kids. Within the next few months, you’ll need to indicate in App Store Connect if your app includes loot boxes available for purchase. In addition, a regional age rating based on local laws will automatically appear on the product page of the apps listed below on the App Store in Australia and South Korea. No other action is needed. Regional age ratings appear in addition to Apple global age ratings.

Australia

A regional age rating is shown if Games is selected as the primary or secondary category in App Store Connect.

15+ regional age rating: Games with loot boxes available for purchase.
18+ regional age rating: Games with Frequent/Intense instances of Simulated Gambling indicated in App Store Connect.
South Korea

A regional age rating is shown if either Games or Entertainment is selected as the primary or secondary category in App Store Connect, or if the app has Frequent/Intense instances of Simulated Gambling in any category.

KR-All regional age rating: Apps and games with an Apple global age rating of 4+ or 9+.
KR-12 regional age rating: Apps and games with an Apple global age rating of 12+. Certain apps and games in this group may receive a KR-15 regional age rating from the South Korean Games Ratings and Administration Committee (GRAC). If this happens, App Review will reach out to impacted developers.
Certain apps and games may receive a KR-18 regional age rating from the GRAC. Instead of a pictogram, text will indicate this rating.
"""

#Preview {
  ContentView2(
    appViewModel: .init(),
    content: .init(text: article)
  )
}
