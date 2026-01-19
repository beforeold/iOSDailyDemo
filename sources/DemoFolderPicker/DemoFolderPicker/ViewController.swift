import UIKit
import UniformTypeIdentifiers

class ViewController: UIViewController, UIDocumentPickerDelegate {

  private let bookmarkKey = "FolderBookmarkData"
  private let pickButton = UIButton(type: .system)
  private let statusLabel = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()

    print(#function)

    view.backgroundColor = .systemBackground
    configureSubviews()
    updateStatusFromCache()
  }

  private func configureSubviews() {
    pickButton.setTitle("Pick Folder", for: .normal)
    pickButton.addTarget(self, action: #selector(pickFolderTapped), for: .touchUpInside)
    pickButton.translatesAutoresizingMaskIntoConstraints = false

    statusLabel.textAlignment = .center
    statusLabel.textColor = .secondaryLabel
    statusLabel.numberOfLines = 0
    statusLabel.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(pickButton)
    view.addSubview(statusLabel)

    NSLayoutConstraint.activate([
      pickButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      pickButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      statusLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      statusLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      statusLabel.topAnchor.constraint(equalTo: pickButton.bottomAnchor, constant: 16)
    ])
  }

  private func updateStatusFromCache() {
    guard let data = UserDefaults.standard.data(forKey: bookmarkKey) else {
      statusLabel.text = "No cached folder bookmark."
      return
    }

    do {
      var isStale = false
      let resolvedURL = try URL(
        resolvingBookmarkData: data,
        options: [],
        relativeTo: nil,
        bookmarkDataIsStale: &isStale
      )
      let fileCount = countFiles(in: resolvedURL)
      let staleNote = isStale ? " (stale)" : ""
      statusLabel.text = "Cached folder\(staleNote): \(resolvedURL.lastPathComponent)\nFiles: \(fileCount)"
      print("Cached folder\(staleNote): \(resolvedURL.path) files=\(fileCount)")
    } catch {
      statusLabel.text = "Cached bookmark invalid: \(error.localizedDescription)"
    }
  }

  @objc private func pickFolderTapped() {
    let picker = UIDocumentPickerViewController(
      forOpeningContentTypes: [UTType.folder],
      asCopy: false
    )
    picker.allowsMultipleSelection = false
    picker.delegate = self
    present(picker, animated: true)
  }

  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let folderURL = urls.first else { return }

    let didStart = folderURL.startAccessingSecurityScopedResource()
    defer {
      if didStart {
        folderURL.stopAccessingSecurityScopedResource()
      }
    }

    do {
      let bookmark = try folderURL.bookmarkData(
        options: [.minimalBookmark],
        includingResourceValuesForKeys: nil,
        relativeTo: nil
      )
      UserDefaults.standard.set(bookmark, forKey: bookmarkKey)
      let fileCount = countFiles(in: folderURL)
      statusLabel.text = "Cached bookmark for: \(folderURL.lastPathComponent)\nFiles: \(fileCount)"
      print("Cached bookmark for: \(folderURL.path) files=\(fileCount)")
    } catch {
      statusLabel.text = "Failed to cache bookmark: \(error.localizedDescription)"
    }
  }

  private func countFiles(in folderURL: URL) -> Int {
    let didStart = folderURL.startAccessingSecurityScopedResource()
    defer {
      if didStart {
        folderURL.stopAccessingSecurityScopedResource()
      }
    }

    var count = 0
    let keys: [URLResourceKey] = [.isRegularFileKey]
    let urls = (try? FileManager.default.contentsOfDirectory(
      at: folderURL,
      includingPropertiesForKeys: keys,
      options: [.skipsHiddenFiles]
    )) ?? []
    for url in urls {
      if let values = try? url.resourceValues(forKeys: Set(keys)),
         values.isRegularFile == true {
        count += 1
      }
    }
    return count
  }
}
