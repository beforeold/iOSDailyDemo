import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
  @StateObject private var store = FolderBookmarkStore()
  @State private var isPickingFolder = false

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Group {
        if let name = store.folderName {
          folderRow(title: "文件夹名称", value: name)
          folderRow(title: "文件数量（含子目录）", value: "\(store.fileCount ?? 0)")
        } else {
          Text("尚未选择文件夹。启动时若钥匙串中已有书签，会自动恢复。")
            .foregroundColor(.secondary)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      if let errorText = store.errorText {
        Text(errorText)
          .font(.footnote)
          .foregroundColor(.red)
      }

      Button("从文件 App 选择文件夹…") {
        isPickingFolder = true
      }
      .buttonStyle(.borderedProminent)
    }
    .padding()
    .fileImporter(
      isPresented: $isPickingFolder,
      allowedContentTypes: [.folder],
      allowsMultipleSelection: false
    ) { result in
      switch result {
      case .success(let urls):
        if let first = urls.first {
          store.handlePickedFolder(at: first)
        }
      case .failure(let error):
        store.errorText = error.localizedDescription
      }
    }
  }

  private func folderRow(title: String, value: String) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .font(.caption)
        .foregroundColor(.secondary)
      Text(value)
        .font(.headline)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
