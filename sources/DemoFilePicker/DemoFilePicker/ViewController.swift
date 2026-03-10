//
//  ViewController.swift
//  DemoFilePicker
//
//  Created by beforeold on 3/10/26.
//

import UIKit
import UniformTypeIdentifiers

final class ViewController: UIViewController {
  private struct PickerRequest {
    let title: String
    let contentTypes: [UTType]
    let asCopy: Bool
  }

  private struct RecentLocation {
    let pickedURL: URL
    let directoryURL: URL
    let isDirectory: Bool
    let sourceDescription: String
  }

  private enum PickerMode: CaseIterable {
    case audio
    case audioVideo
    case directory
    case audioVideoDirectory

    var title: String {
      switch self {
      case .audio:
        return "选择 Audio"
      case .audioVideo:
        return "选择 Audio + Video"
      case .directory:
        return "选择 Directory"
      case .audioVideoDirectory:
        return "选择 Audio + Video + Directory"
      }
    }

    var requests: [PickerRequest] {
      switch self {
      case .audio:
        return [
          PickerRequest(
            title: "选择 Audio",
            contentTypes: [.audio],
            asCopy: false
          )
        ]
      case .audioVideo:
        return [
          PickerRequest(
            title: "选择 Audio + Video",
            contentTypes: [.audio, .movie, .video],
            asCopy: false
          )
        ]
      case .directory:
        return [
          PickerRequest(
            title: "选择 Directory",
            contentTypes: [.folder],
            asCopy: false
          )
        ]
      case .audioVideoDirectory:
        return [
          PickerRequest(
            title: "选择 Audio + Video",
            contentTypes: [.audio, .movie, .video],
            asCopy: false
          ),
          PickerRequest(
            title: "选择 Directory",
            contentTypes: [.folder],
            asCopy: false
          )
        ]
      }
    }
  }

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = .preferredFont(forTextStyle: .body)
    label.text = "点击下面的入口打开文件选择器。选择结果会打印到控制台，并显示在下方日志区域。"
    return label
  }()

  private let contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.alwaysBounceVertical = true
    return scrollView
  }()

  private let contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 12
    return stackView
  }()

  private let directorySelectionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = .preferredFont(forTextStyle: .footnote)
    label.textColor = .secondaryLabel
    return label
  }()

  private let clearDirectoryButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("清空下一次 directoryURL", for: .normal)
    return button
  }()

  private let recentHeaderLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = .preferredFont(forTextStyle: .headline)
    label.text = "最近 Pick URL"
    return label
  }()

  private let recentScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.backgroundColor = .secondarySystemBackground
    scrollView.layer.cornerRadius = 12
    return scrollView
  }()

  private let recentStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    stackView.isLayoutMarginsRelativeArrangement = true
    return stackView
  }()

  private let logTextView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.isEditable = false
    textView.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
    textView.backgroundColor = .secondarySystemBackground
    textView.layer.cornerRadius = 12
    textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    return textView
  }()

  private var currentRequest: PickerRequest?
  private var recentLocations: [RecentLocation] = []
  private var preferredDirectoryURL: URL?

  private let maximumRecentLocations = 12

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    configureButtons()
    clearDirectoryButton.addTarget(self, action: #selector(clearPreferredDirectory), for: .touchUpInside)
    refreshDirectorySelectionUI()
    refreshRecentLocationsUI()
    appendLog("Demo ready")
  }

  private func configureView() {
    view.backgroundColor = .systemBackground

    view.addSubview(contentScrollView)
    contentScrollView.addSubview(contentView)

    contentView.addSubview(descriptionLabel)
    contentView.addSubview(buttonStackView)
    contentView.addSubview(directorySelectionLabel)
    contentView.addSubview(clearDirectoryButton)
    contentView.addSubview(recentHeaderLabel)
    contentView.addSubview(recentScrollView)
    contentView.addSubview(logTextView)

    recentScrollView.addSubview(recentStackView)

    let guide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      contentScrollView.topAnchor.constraint(equalTo: guide.topAnchor),
      contentScrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      contentScrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
      contentScrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),

      contentView.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.widthAnchor),

      descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

      buttonStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
      buttonStackView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
      buttonStackView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),

      directorySelectionLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20),
      directorySelectionLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
      directorySelectionLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),

      clearDirectoryButton.topAnchor.constraint(equalTo: directorySelectionLabel.bottomAnchor, constant: 8),
      clearDirectoryButton.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),

      recentHeaderLabel.topAnchor.constraint(equalTo: clearDirectoryButton.bottomAnchor, constant: 16),
      recentHeaderLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
      recentHeaderLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),

      recentScrollView.topAnchor.constraint(equalTo: recentHeaderLabel.bottomAnchor, constant: 8),
      recentScrollView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
      recentScrollView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
      recentScrollView.heightAnchor.constraint(equalToConstant: 170),

      recentStackView.topAnchor.constraint(equalTo: recentScrollView.contentLayoutGuide.topAnchor),
      recentStackView.leadingAnchor.constraint(equalTo: recentScrollView.contentLayoutGuide.leadingAnchor),
      recentStackView.trailingAnchor.constraint(equalTo: recentScrollView.contentLayoutGuide.trailingAnchor),
      recentStackView.bottomAnchor.constraint(equalTo: recentScrollView.contentLayoutGuide.bottomAnchor),
      recentStackView.widthAnchor.constraint(equalTo: recentScrollView.frameLayoutGuide.widthAnchor),

      logTextView.topAnchor.constraint(equalTo: recentScrollView.bottomAnchor, constant: 20),
      logTextView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
      logTextView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
      logTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
      logTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 180)
    ])
  }

  private func configureButtons() {
    PickerMode.allCases.forEach { mode in
      let button = UIButton(type: .system)
      button.configuration = .filled()
      button.configuration?.title = mode.title
      button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
      button.tag = tag(for: mode)
      button.addTarget(self, action: #selector(openPicker(_:)), for: .touchUpInside)
      buttonStackView.addArrangedSubview(button)
    }
  }

  @objc
  private func openPicker(_ sender: UIButton) {
    guard let mode = mode(for: sender.tag) else { return }
    let requests = mode.requests
    if requests.count == 1, let request = requests.first {
      presentPicker(for: request)
      return
    }

    let alert = UIAlertController(title: mode.title, message: "目录与媒体不能在同一个 document picker 中同时作为可选项，先选择本次要挑选的类型。", preferredStyle: .actionSheet)
    requests.forEach { request in
      alert.addAction(UIAlertAction(title: request.title, style: .default) { [weak self] _ in
        self?.presentPicker(for: request)
      })
    }
    alert.addAction(UIAlertAction(title: "取消", style: .cancel))

    if let popover = alert.popoverPresentationController {
      popover.sourceView = sender
      popover.sourceRect = sender.bounds
    }

    present(alert, animated: true)
    appendLog("Open options: \(mode.title)")
  }

  private func presentPicker(for request: PickerRequest) {
    currentRequest = request

    let picker = UIDocumentPickerViewController(forOpeningContentTypes: request.contentTypes, asCopy: request.asCopy)
    picker.delegate = self
    picker.allowsMultipleSelection = true
    picker.modalPresentationStyle = .formSheet
    picker.directoryURL = preferredDirectoryURL
    present(picker, animated: true)

    if let preferredDirectoryURL {
      appendLog("Use directoryURL: \(preferredDirectoryURL.path)")
    }
    appendLog("Open picker: \(request.title)")
  }

  private func appendLog(_ message: String) {
    let timestamp = Self.logDateFormatter.string(from: Date())
    let line = "[\(timestamp)] \(message)"
    print(line)

    if logTextView.text.isEmpty {
      logTextView.text = line
    } else {
      logTextView.text += "\n\n\(line)"
    }

    let endRange = NSRange(location: max(logTextView.text.count - 1, 0), length: 1)
    logTextView.scrollRangeToVisible(endRange)
  }

  private func logDetails(for url: URL) {
    let hasSecurityScope = url.startAccessingSecurityScopedResource()
    defer {
      if hasSecurityScope {
        url.stopAccessingSecurityScopedResource()
      }
    }

    let values = try? url.resourceValues(forKeys: [
      .isDirectoryKey,
      .fileSizeKey,
      .contentTypeKey,
      .nameKey,
      .creationDateKey,
      .contentModificationDateKey
    ])

    let isDirectory = values?.isDirectory ?? false
    let sizeText: String
    if let fileSize = values?.fileSize, !isDirectory {
      sizeText = ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    } else {
      sizeText = "-"
    }

    let detail = """
    name: \(values?.name ?? url.lastPathComponent)
    path: \(url.path)
    type: \(values?.contentType?.identifier ?? "unknown")
    isDirectory: \(isDirectory)
    size: \(sizeText)
    created: \(Self.detailDateFormatter.string(from: values?.creationDate))
    modified: \(Self.detailDateFormatter.string(from: values?.contentModificationDate))
    """

    appendLog(detail)
  }

  private func recordRecentLocation(for url: URL) {
    let locations = buildRecentLocations(from: url)
    locations.reversed().forEach(insertRecentLocation(_:))
    refreshRecentLocationsUI()
  }

  private func insertRecentLocation(_ location: RecentLocation) {
    recentLocations.removeAll {
      $0.pickedURL == location.pickedURL &&
      $0.directoryURL == location.directoryURL &&
      $0.sourceDescription == location.sourceDescription
    }
    recentLocations.insert(location, at: 0)
    if recentLocations.count > maximumRecentLocations {
      recentLocations.removeLast(recentLocations.count - maximumRecentLocations)
    }
  }

  private func buildRecentLocations(from url: URL) -> [RecentLocation] {
    let hasSecurityScope = url.startAccessingSecurityScopedResource()
    defer {
      if hasSecurityScope {
        url.stopAccessingSecurityScopedResource()
      }
    }

    let isDirectory = (try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? url.hasDirectoryPath
    if isDirectory {
      return [
        RecentLocation(
          pickedURL: url,
          directoryURL: url,
          isDirectory: true,
          sourceDescription: "Picked Directory"
        )
      ]
    }

    let directoryURL = url.deletingLastPathComponent()
    return [
      RecentLocation(
        pickedURL: url,
        directoryURL: directoryURL,
        isDirectory: false,
        sourceDescription: "Picked File"
      ),
      RecentLocation(
        pickedURL: directoryURL,
        directoryURL: directoryURL,
        isDirectory: true,
        sourceDescription: "File Directory"
      )
    ]
  }

  private func refreshDirectorySelectionUI() {
    if let preferredDirectoryURL {
      directorySelectionLabel.text = "下一次 picker.directoryURL:\n\(preferredDirectoryURL.path)"
      clearDirectoryButton.isEnabled = true
    } else {
      directorySelectionLabel.text = "下一次 picker.directoryURL: 系统默认"
      clearDirectoryButton.isEnabled = false
    }
  }

  private func refreshRecentLocationsUI() {
    recentStackView.arrangedSubviews.forEach { view in
      recentStackView.removeArrangedSubview(view)
      view.removeFromSuperview()
    }

    guard !recentLocations.isEmpty else {
      let label = UILabel()
      label.numberOfLines = 0
      label.font = .preferredFont(forTextStyle: .footnote)
      label.textColor = .secondaryLabel
      label.text = "暂无记录。每次 pick 后都会把 URL 加到这里，点击任意一条即可把它的目录设置为下一次 picker 的 directoryURL。"
      recentStackView.addArrangedSubview(label)
      return
    }

    for (index, location) in recentLocations.enumerated() {
      let button = UIButton(type: .system)
      button.tag = index
      button.configuration = .plain()
      button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)
      button.contentHorizontalAlignment = .leading
      button.titleLabel?.numberOfLines = 0
      button.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
      button.layer.cornerRadius = 10
      button.layer.masksToBounds = true
      button.backgroundColor = location.directoryURL == preferredDirectoryURL ? UIColor.systemBlue.withAlphaComponent(0.14) : .tertiarySystemBackground

      let kind = location.isDirectory ? "Directory" : "File"
      var title = "\(location.sourceDescription) | \(kind): \(location.pickedURL.lastPathComponent)\nURL: \(location.pickedURL.path)\nNext directoryURL: \(location.directoryURL.path)"
      if location.directoryURL == preferredDirectoryURL {
        title = "当前已选\n" + title
      }
      button.setTitle(title, for: .normal)
      button.addTarget(self, action: #selector(selectRecentLocation(_:)), for: .touchUpInside)
      recentStackView.addArrangedSubview(button)
    }
  }

  @objc
  private func selectRecentLocation(_ sender: UIButton) {
    guard recentLocations.indices.contains(sender.tag) else { return }
    let location = recentLocations[sender.tag]
    preferredDirectoryURL = location.directoryURL
    refreshDirectorySelectionUI()
    refreshRecentLocationsUI()
    appendLog("Set next directoryURL from picked URL: \(location.pickedURL.path)")
  }

  @objc
  private func clearPreferredDirectory() {
    preferredDirectoryURL = nil
    refreshDirectorySelectionUI()
    refreshRecentLocationsUI()
    appendLog("Cleared next directoryURL")
  }

  private func tag(for mode: PickerMode) -> Int {
    switch mode {
    case .audio:
      return 1
    case .audioVideo:
      return 2
    case .directory:
      return 3
    case .audioVideoDirectory:
      return 4
    }
  }

  private func mode(for tag: Int) -> PickerMode? {
    switch tag {
    case 1:
      return .audio
    case 2:
      return .audioVideo
    case 3:
      return .directory
    case 4:
      return .audioVideoDirectory
    default:
      return nil
    }
  }

  private static let logDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter
  }()

  private static let detailDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
  }()
}

extension ViewController: UIDocumentPickerDelegate {
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    let modeTitle = currentRequest?.title ?? "未知模式"
    appendLog("Picked \(urls.count) item(s) from \(modeTitle)")
    urls.forEach {
      recordRecentLocation(for: $0)
      logDetails(for: $0)
    }
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    appendLog("Picker cancelled")
  }
}

private extension DateFormatter {
  func string(from date: Date?) -> String {
    guard let date else { return "-" }
    return string(from: date)
  }
}
