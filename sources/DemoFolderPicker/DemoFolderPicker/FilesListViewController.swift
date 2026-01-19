import UIKit
import QuickLookThumbnailing

final class FilesListViewController: UITableViewController {

  private let fileURLs: [URL]
  private let folderURL: URL?
  private let didStartAccess: Bool
  private let thumbnailCache = NSCache<NSURL, UIImage>()
  private let placeholderImage = UIImage(systemName: "doc")

  init(fileURLs: [URL], folderURL: URL?, didStartAccess: Bool) {
    self.fileURLs = fileURLs
    self.folderURL = folderURL
    self.didStartAccess = didStartAccess
    super.init(style: .plain)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    if didStartAccess {
      folderURL?.stopAccessingSecurityScopedResource()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FileCell")
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(doneTapped)
    )
  }

  @objc private func doneTapped() {
    dismiss(animated: true)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    fileURLs.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath)
    let url = fileURLs[indexPath.row]
    cell.textLabel?.text = url.lastPathComponent
    cell.imageView?.image = placeholderImage

    if let cached = thumbnailCache.object(forKey: url as NSURL) {
      cell.imageView?.image = cached
    } else {
      requestThumbnail(for: url, at: indexPath)
    }
    return cell
  }

  private func requestThumbnail(for url: URL, at indexPath: IndexPath) {
    let size = CGSize(width: 60, height: 60)
    let scale = UIScreen.main.scale
    let request = QLThumbnailGenerator.Request(
      fileAt: url,
      size: size,
      scale: scale,
      representationTypes: .thumbnail
    )
    QLThumbnailGenerator.shared.generateBestRepresentation(for: request) { [weak self] representation, _ in
      guard let self, let image = representation?.uiImage else { return }
      DispatchQueue.main.async {
        self.thumbnailCache.setObject(image, forKey: url as NSURL)
        if let cell = self.tableView.cellForRow(at: indexPath) {
          cell.imageView?.image = image
          cell.setNeedsLayout()
        }
      }
    }
  }
}
