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

    var subtitle: String {
      switch self {
      case .audio:
        return "仅选择音频文件"
      case .audioVideo:
        return "一起筛选音频和视频"
      case .directory:
        return "直接选择文件夹"
      case .audioVideoDirectory:
        return "先选媒体或目录，再进入 picker"
      }
    }

    var iconName: String {
      switch self {
      case .audio:
        return "waveform"
      case .audioVideo:
        return "film.stack"
      case .directory:
        return "folder"
      case .audioVideoDirectory:
        return "square.stack.3d.up"
      }
    }

    var accentColor: UIColor {
      switch self {
      case .audio:
        return UIColor(red: 0.12, green: 0.50, blue: 0.49, alpha: 1)
      case .audioVideo:
        return UIColor(red: 0.16, green: 0.34, blue: 0.56, alpha: 1)
      case .directory:
        return UIColor(red: 0.70, green: 0.43, blue: 0.16, alpha: 1)
      case .audioVideoDirectory:
        return UIColor(red: 0.29, green: 0.47, blue: 0.28, alpha: 1)
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
    label.textColor = UIColor(white: 1, alpha: 0.82)
    label.text = "用四种入口测试 audio、video 和 directory 选择流程，并复用最近一次的目录作为下一次 picker 的起点。"
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
    stackView.spacing = 14
    return stackView
  }()

  private let directorySelectionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = .preferredFont(forTextStyle: .body)
    label.textColor = UIColor(red: 0.16, green: 0.19, blue: 0.22, alpha: 1)
    return label
  }()

  private let clearDirectoryButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    var configuration = UIButton.Configuration.tinted()
    configuration.title = "清空 directoryURL"
    configuration.image = UIImage(systemName: "arrow.counterclockwise")
    configuration.imagePadding = 6
    configuration.cornerStyle = .capsule
    configuration.baseForegroundColor = UIColor(red: 0.61, green: 0.35, blue: 0.17, alpha: 1)
    configuration.baseBackgroundColor = UIColor(red: 0.94, green: 0.88, blue: 0.80, alpha: 1)
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
    button.configuration = configuration
    return button
  }()

  private let recentScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.backgroundColor = UIColor(red: 0.98, green: 0.97, blue: 0.95, alpha: 1)
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
    textView.textColor = UIColor(red: 0.88, green: 0.92, blue: 0.95, alpha: 1)
    textView.backgroundColor = UIColor(red: 0.12, green: 0.15, blue: 0.19, alpha: 1)
    textView.layer.cornerRadius = 18
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
    view.backgroundColor = UIColor(red: 0.95, green: 0.93, blue: 0.89, alpha: 1)

    view.addSubview(contentScrollView)
    contentScrollView.addSubview(contentView)

    let contentStackView = UIStackView()
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    contentStackView.axis = .vertical
    contentStackView.spacing = 20
    contentView.addSubview(contentStackView)

    recentScrollView.addSubview(recentStackView)

    let heroCardView = makeCardView(
      backgroundColor: UIColor(red: 0.16, green: 0.22, blue: 0.25, alpha: 1),
      borderColor: UIColor(red: 0.24, green: 0.31, blue: 0.34, alpha: 1),
      shadowColor: UIColor.black.withAlphaComponent(0.18)
    )
    let heroEyebrowLabel = makeHeaderLabel(
      text: "FILE PICKER DEMO",
      font: .systemFont(ofSize: 12, weight: .semibold),
      color: UIColor(red: 0.92, green: 0.77, blue: 0.51, alpha: 1)
    )
    let heroTitleLabel = makeHeaderLabel(
      text: "一个更像 Demo 的文件选择页",
      font: .systemFont(ofSize: 28, weight: .bold),
      color: .white
    )
    let heroChipStackView = UIStackView(arrangedSubviews: [
      makeChipButton(title: "4 种入口"),
      makeChipButton(title: "记录 URL"),
      makeChipButton(title: "复用 directoryURL")
    ])
    heroChipStackView.axis = .horizontal
    heroChipStackView.spacing = 8
    heroChipStackView.alignment = .leading

    let heroStackView = UIStackView(arrangedSubviews: [
      heroEyebrowLabel,
      heroTitleLabel,
      descriptionLabel,
      heroChipStackView
    ])
    heroStackView.translatesAutoresizingMaskIntoConstraints = false
    heroStackView.axis = .vertical
    heroStackView.spacing = 12
    heroCardView.addSubview(heroStackView)

    let actionsCardView = makeSectionCard(
      title: "Pick Scenarios",
      subtitle: "把四种入口整理成清晰的操作卡片，方便和设计稿或 QA 流程一起演示。",
      contentView: buttonStackView
    )

    let directoryControlStackView = UIStackView(arrangedSubviews: [directorySelectionLabel, clearDirectoryButton])
    directoryControlStackView.axis = .vertical
    directoryControlStackView.spacing = 14
    directoryControlStackView.alignment = .leading
    let directoryCardView = makeSectionCard(
      title: "Start Location",
      subtitle: "点击最近记录即可把它的目录设置成下一次 `picker.directoryURL`。",
      contentView: directoryControlStackView
    )

    let recentCardView = makeSectionCard(
      title: "Recent Picks",
      subtitle: "选择文件时会额外记录它的父目录，这样下次可以直接从同一目录继续。",
      contentView: recentScrollView
    )

    let logCardView = makeSectionCard(
      title: "Live Console",
      subtitle: "打开 picker、设置目录、选择结果，都会实时打印在这里。",
      contentView: logTextView,
      backgroundColor: UIColor(red: 0.19, green: 0.23, blue: 0.27, alpha: 1),
      borderColor: UIColor(red: 0.26, green: 0.31, blue: 0.36, alpha: 1),
      shadowColor: UIColor.black.withAlphaComponent(0.14),
      isDark: true
    )

    contentStackView.addArrangedSubview(heroCardView)
    contentStackView.addArrangedSubview(actionsCardView)
    contentStackView.addArrangedSubview(directoryCardView)
    contentStackView.addArrangedSubview(recentCardView)
    contentStackView.addArrangedSubview(logCardView)

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

      contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

      heroStackView.topAnchor.constraint(equalTo: heroCardView.topAnchor, constant: 22),
      heroStackView.leadingAnchor.constraint(equalTo: heroCardView.leadingAnchor, constant: 22),
      heroStackView.trailingAnchor.constraint(equalTo: heroCardView.trailingAnchor, constant: -22),
      heroStackView.bottomAnchor.constraint(equalTo: heroCardView.bottomAnchor, constant: -22),

      recentScrollView.heightAnchor.constraint(equalToConstant: 188),
      recentStackView.topAnchor.constraint(equalTo: recentScrollView.contentLayoutGuide.topAnchor),
      recentStackView.leadingAnchor.constraint(equalTo: recentScrollView.contentLayoutGuide.leadingAnchor),
      recentStackView.trailingAnchor.constraint(equalTo: recentScrollView.contentLayoutGuide.trailingAnchor),
      recentStackView.bottomAnchor.constraint(equalTo: recentScrollView.contentLayoutGuide.bottomAnchor),
      recentStackView.widthAnchor.constraint(equalTo: recentScrollView.frameLayoutGuide.widthAnchor),

      logTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 210)
    ])
  }

  private func configureButtons() {
    PickerMode.allCases.forEach { mode in
      let button = UIButton(type: .system)
      var configuration = UIButton.Configuration.filled()
      configuration.title = mode.title
      configuration.subtitle = mode.subtitle
      configuration.image = UIImage(systemName: mode.iconName)
      configuration.imagePlacement = .leading
      configuration.imagePadding = 12
      configuration.baseBackgroundColor = mode.accentColor
      configuration.baseForegroundColor = .white
      configuration.cornerStyle = .large
      configuration.buttonSize = .large
      configuration.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 18, bottom: 18, trailing: 18)
      button.configuration = configuration
      button.contentHorizontalAlignment = .leading
      button.layer.cornerRadius = 22
      button.layer.shadowColor = mode.accentColor.withAlphaComponent(0.35).cgColor
      button.layer.shadowOpacity = 1
      button.layer.shadowRadius = 18
      button.layer.shadowOffset = CGSize(width: 0, height: 10)
      button.tag = tag(for: mode)
      button.addTarget(self, action: #selector(openPicker(_:)), for: .touchUpInside)
      buttonStackView.addArrangedSubview(button)
    }
  }

  private func makeCardView(
    backgroundColor: UIColor,
    borderColor: UIColor,
    shadowColor: UIColor
  ) -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = backgroundColor
    view.layer.cornerRadius = 28
    view.layer.borderWidth = 1
    view.layer.borderColor = borderColor.cgColor
    view.layer.shadowColor = shadowColor.cgColor
    view.layer.shadowOpacity = 1
    view.layer.shadowRadius = 22
    view.layer.shadowOffset = CGSize(width: 0, height: 12)
    return view
  }

  private func makeSectionCard(
    title: String,
    subtitle: String,
    contentView: UIView,
    backgroundColor: UIColor = UIColor(red: 0.99, green: 0.98, blue: 0.96, alpha: 1),
    borderColor: UIColor = UIColor(red: 0.89, green: 0.85, blue: 0.79, alpha: 1),
    shadowColor: UIColor = UIColor(red: 0.43, green: 0.36, blue: 0.27, alpha: 0.12),
    isDark: Bool = false
  ) -> UIView {
    let cardView = makeCardView(backgroundColor: backgroundColor, borderColor: borderColor, shadowColor: shadowColor)
    let headerStackView = makeSectionHeader(title: title, subtitle: subtitle, isDark: isDark)
    let stackView = UIStackView(arrangedSubviews: [headerStackView, contentView])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 16
    cardView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
      stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
      stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
      stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20)
    ])
    return cardView
  }

  private func makeSectionHeader(title: String, subtitle: String, isDark: Bool = false) -> UIStackView {
    let titleLabel = makeHeaderLabel(
      text: title,
      font: .systemFont(ofSize: 20, weight: .semibold),
      color: isDark ? .white : UIColor(red: 0.16, green: 0.19, blue: 0.22, alpha: 1)
    )
    let subtitleLabel = makeHeaderLabel(
      text: subtitle,
      font: .systemFont(ofSize: 14, weight: .regular),
      color: isDark ? UIColor(white: 1, alpha: 0.72) : UIColor(red: 0.43, green: 0.43, blue: 0.41, alpha: 1)
    )
    subtitleLabel.numberOfLines = 0
    let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    stackView.axis = .vertical
    stackView.spacing = 6
    return stackView
  }

  private func makeHeaderLabel(text: String, font: UIFont, color: UIColor) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = font
    label.textColor = color
    label.text = text
    return label
  }

  private func makeChipButton(title: String) -> UIButton {
    let button = UIButton(type: .system)
    button.isUserInteractionEnabled = false
    var configuration = UIButton.Configuration.tinted()
    configuration.title = title
    configuration.baseForegroundColor = UIColor(red: 0.16, green: 0.22, blue: 0.25, alpha: 1)
    configuration.baseBackgroundColor = UIColor(red: 0.92, green: 0.77, blue: 0.51, alpha: 1)
    configuration.cornerStyle = .capsule
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)
    button.configuration = configuration
    return button
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
      let title = "已锁定下一次起始目录"
      let body = "\(condensedPath(preferredDirectoryURL))\n\(preferredDirectoryURL.path)"
      let attributedText = NSMutableAttributedString(
        string: title + "\n",
        attributes: [
          .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
          .foregroundColor: UIColor(red: 0.16, green: 0.19, blue: 0.22, alpha: 1)
        ]
      )
      attributedText.append(
        NSAttributedString(
          string: body,
          attributes: [
            .font: UIFont.monospacedSystemFont(ofSize: 13, weight: .regular),
            .foregroundColor: UIColor(red: 0.45, green: 0.41, blue: 0.34, alpha: 1)
          ]
        )
      )
      directorySelectionLabel.attributedText = attributedText
      clearDirectoryButton.isEnabled = true
    } else {
      let attributedText = NSMutableAttributedString(
        string: "当前使用系统默认起始目录\n",
        attributes: [
          .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
          .foregroundColor: UIColor(red: 0.16, green: 0.19, blue: 0.22, alpha: 1)
        ]
      )
      attributedText.append(
        NSAttributedString(
          string: "还没有指定 `picker.directoryURL`，系统会从默认位置开始。",
          attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor(red: 0.45, green: 0.43, blue: 0.41, alpha: 1)
          ]
        )
      )
      directorySelectionLabel.attributedText = attributedText
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
      var configuration = UIButton.Configuration.tinted()
      configuration.image = UIImage(systemName: location.isDirectory ? "folder.fill" : "doc.fill")
      configuration.imagePadding = 10
      configuration.imagePlacement = .leading
      configuration.cornerStyle = .large
      configuration.baseForegroundColor = UIColor(red: 0.19, green: 0.22, blue: 0.26, alpha: 1)
      configuration.baseBackgroundColor = location.directoryURL == preferredDirectoryURL
        ? UIColor(red: 0.87, green: 0.92, blue: 0.84, alpha: 1)
        : UIColor(red: 0.95, green: 0.93, blue: 0.89, alpha: 1)
      configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
      button.configuration = configuration
      button.contentHorizontalAlignment = .leading
      button.titleLabel?.numberOfLines = 0
      button.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
      button.layer.cornerRadius = 10
      button.layer.masksToBounds = true

      let kind = location.isDirectory ? "Directory" : "File"
      var title = "\(location.sourceDescription) | \(kind): \(location.pickedURL.lastPathComponent)\nURL: \(condensedPath(location.pickedURL))\nNext: \(condensedPath(location.directoryURL))"
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

  private func condensedPath(_ url: URL) -> String {
    let components = url.pathComponents.filter { $0 != "/" }
    guard components.count > 4 else { return url.path }
    return "…/" + components.suffix(4).joined(separator: "/")
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
