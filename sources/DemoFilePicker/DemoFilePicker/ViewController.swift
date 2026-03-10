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
            asCopy: true
          )
        ]
      case .audioVideo:
        return [
          PickerRequest(
            title: "选择 Audio + Video",
            contentTypes: [.audio, .movie, .video],
            asCopy: true
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
            asCopy: true
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

  private let buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 12
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

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    configureButtons()
    appendLog("Demo ready")
  }

  private func configureView() {
    view.backgroundColor = .systemBackground

    view.addSubview(descriptionLabel)
    view.addSubview(buttonStackView)
    view.addSubview(logTextView)

    let guide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
      descriptionLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
      descriptionLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),

      buttonStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
      buttonStackView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
      buttonStackView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),

      logTextView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20),
      logTextView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
      logTextView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
      logTextView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -20),
      logTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 240)
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
    present(picker, animated: true)

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
    urls.forEach(logDetails(for:))
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
