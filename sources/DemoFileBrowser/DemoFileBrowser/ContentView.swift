import FileBrowser
import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
  @State private var editing: URL?

  var body: some View {
    VStack {
      Text("Hello")

      FileBrowserView(
        utType: .jpeg,
        pathExtension: "jpeg",
        newDocumentURL: URL.documentsDirectory,
        documentSelected: { selectedUrl in

        },
        thumbnailName: nil,
        exclude: [],
        showSettings: {},
        doImport: {},
        showIntro: {}
        //        editing: $editing,
        //        utType: UTType("com.yourcompany.yourformat")!,
        //        pathExtension: "myextension",
        //        newDocumentURL: Bundle.main.url(forResource: "New Document", withExtension: "myextension")!,
      )

    }
    .padding()
  }
}

#Preview {
  ContentView()
}
