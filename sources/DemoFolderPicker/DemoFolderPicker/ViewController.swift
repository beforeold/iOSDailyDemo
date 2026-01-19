import UIKit
import UniformTypeIdentifiers

class ViewController: UIViewController, UIDocumentPickerDelegate {

  private let bookmarkKey = "FolderBookmarkData"
  private let pickButton = UIButton(type: .system)
  private let previewButton = UIButton(type: .system)
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

    previewButton.setTitle("Preview Files", for: .normal)
    previewButton.addTarget(self, action: #selector(previewFilesTapped), for: .touchUpInside)
    previewButton.translatesAutoresizingMaskIntoConstraints = false

    statusLabel.textAlignment = .center
    statusLabel.textColor = .secondaryLabel
    statusLabel.numberOfLines = 0
    statusLabel.translatesAutoresizingMaskIntoConstraints = false

    let stackView = UIStackView(arrangedSubviews: [pickButton, statusLabel, previewButton])
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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

  @objc private func previewFilesTapped() {
    guard let folderURL = resolveCachedFolderURL() else {
      let alert = UIAlertController(
        title: "No Folder",
        message: "Pick a folder first to preview files.",
        preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      present(alert, animated: true)
      return
    }

    let didStart = folderURL.startAccessingSecurityScopedResource()
    let urls = fileURLs(in: folderURL)
    let listController = FilesListViewController(
      fileURLs: urls,
      folderURL: didStart ? folderURL : nil,
      didStartAccess: didStart
    )
    listController.title = folderURL.lastPathComponent
    let navController = UINavigationController(rootViewController: listController)
    present(navController, animated: true)
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
      print("File: \(url.lastPathComponent)")
      if let values = try? url.resourceValues(forKeys: Set(keys)),
         values.isRegularFile == true {
        count += 1
      }
    }
    return count
  }

  private func fileURLs(in folderURL: URL) -> [URL] {
    let keys: [URLResourceKey] = [.isRegularFileKey]
    let urls = (try? FileManager.default.contentsOfDirectory(
      at: folderURL,
      includingPropertiesForKeys: keys,
      options: [.skipsHiddenFiles]
    )) ?? []
    return urls.filter { url in
      (try? url.resourceValues(forKeys: Set(keys)).isRegularFile) == true
    }
  }

  private func resolveCachedFolderURL() -> URL? {
    guard let data = UserDefaults.standard.data(forKey: bookmarkKey) else {
      return nil
    }
    do {
      var isStale = false
      return try URL(
        resolvingBookmarkData: data,
        options: [],
        relativeTo: nil,
        bookmarkDataIsStale: &isStale
      )
    } catch {
      return nil
    }
  }
}
