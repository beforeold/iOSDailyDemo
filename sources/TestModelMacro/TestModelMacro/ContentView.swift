import SwiftData
import SwiftUI

 @MainActor
class Manager {
  /// Helper methods
  private func createDocument() {
    // guard let scanDocument else { return }
  //  isLoading = true
    Task.detached(priority: .high) {
      _ = Document(name: "documentName")
      //这里警告： Expression is 'async' but is not marked with 'await'; this is an error in the Swift 6 language mode。 系统建设修改 let document = await Document(name: documentName)

  //    var pages: [DocumentPage] = []
  //
  //    for pageIndex in 0..<scanDocument.pageCount {
  //      let pageImage = scanDocument.imageOfPage(at: pageIndex)
  //
  //      guard let pageData = pageImage.jpegData(compressionQuality: 0.65) else { return }
  //      let documentPage = DocumentPage(document: document, pageIndex: pageIndex, pageData: pageData)
  //      pages.append(documentPage)
  //    }
  //
  //    document.pages = pages
  //
  //    ///Saving data on main thread
  //    await MainActor.run {
  //      context.insert(document)
  //      try? context.save()
  //
  //      /// Resetting Data
  //      self.scanDocument = nil
  //      isLoading = false
  //      self.documentName = "New Document"
  //    }
    }
  }
}

// 其中的Document定义如下：
// @MainActor
@Model
class Document {
  var name: String
  var createdAt: Date = Date()
  @Relationship(deleteRule: .cascade, inverse: \DocumentPage.document)
  var pages: [DocumentPage]?
  var isLocked: Bool = false
  /// For Zoom Transition
  var uniqueViewID: String = UUID().uuidString

  init(name: String, pages: [DocumentPage]? = nil) {
    self.name = name
    self.pages = pages
  }
}

@Model
class DocumentPage {
  var document: Document?
  var pageIndex: Int

  /// Since it holds image data of each document page
  @Attribute(.externalStorage)
  var pageData: Data

  init(document: Document? = nil, pageIndex: Int, pageData: Data) {
    self.document = document
    self.pageIndex = pageIndex
    self.pageData = pageData
  }
}

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
