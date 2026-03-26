//
//  DocumentSheetViewController.swift
//  DemoSheetDocumentPikcer
//

import UIKit
import UniformTypeIdentifiers
import FloatingPanel

// MARK: - DocumentSheetViewController

class DocumentSheetViewController: UIViewController {
  private var isPresentingDocumentPicker = false {
    didSet {
      pickerButton.isEnabled = !isPresentingDocumentPicker
      floatingPanelButton.isEnabled = !isPresentingDocumentPicker
    }
  }

  // MARK: - UI

  private lazy var pickerButton: UIButton = {
    var config = UIButton.Configuration.filled()
    config.title = "Document Picker"
    config.cornerStyle = .medium
    let btn = UIButton(configuration: config)
    btn.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
    return btn
  }()

  private lazy var browserButton: UIButton = {
    var config = UIButton.Configuration.filled()
    config.title = "Document Browser"
    config.cornerStyle = .medium
    let btn = UIButton(configuration: config)
    btn.addTarget(self, action: #selector(showBrowser), for: .touchUpInside)
    return btn
  }()

  private lazy var floatingPanelButton: UIButton = {
    var config = UIButton.Configuration.filled()
    config.title = "FloatingPanel Picker"
    config.baseBackgroundColor = .systemGreen
    config.cornerStyle = .medium
    let btn = UIButton(configuration: config)
    btn.addTarget(self, action: #selector(showFloatingPanelPicker), for: .touchUpInside)
    return btn
  }()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "UIKit Sheet"
    view.backgroundColor = .systemBackground

    let stack = UIStackView(arrangedSubviews: [pickerButton, browserButton, floatingPanelButton])
    stack.axis = .vertical
    stack.spacing = 20
    stack.alignment = .center
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)

    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }

  // MARK: - Actions

  @objc private func showPicker() {
    guard !isPresentingDocumentPicker else { return }
    isPresentingDocumentPicker = true

    let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
    picker.allowsMultipleSelection = true

    let sheet = NativeSheetContainerController(content: picker)
    sheet.onDismiss = { [weak self] in
      self?.isPresentingDocumentPicker = false
    }
    present(sheet, animated: false)
  }

  @objc private func showBrowser() {
    let browser = UIDocumentBrowserViewController(forOpening: [.item])
    browser.allowsDocumentCreation = false
    browser.allowsPickingMultipleItems = false
    presentAsSheet(browser)
  }

  @objc private func showFloatingPanelPicker() {
    guard !isPresentingDocumentPicker else { return }
    isPresentingDocumentPicker = true

    let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
    picker.allowsMultipleSelection = true

    let fpc = FloatingPanelController()
    fpc.set(contentViewController: picker)
    fpc.layout = DocumentPickerFloatingLayout()
    fpc.isRemovalInteractionEnabled = true
    fpc.surfaceView.grabberHandle.isHidden = false
    fpc.surfaceView.appearance.cornerRadius = 16
    fpc.surfaceView.grabberHandlePadding = 12
    fpc.delegate = self
    fpc.contentMode = .fitToBounds
    fpc.panGestureRecognizer.isEnabled = true

    present(fpc, animated: true)
  }

  // MARK: - Sheet Presentation (仅用于 Document Browser)

  /// 注意：此方法仅用于 UIDocumentBrowserViewController。
  /// UIDocumentPickerViewController 已改用 NativeSheetContainerController，
  /// 以规避 iOS 26 dark mode + medium detent 下的发灰问题。
  private func presentAsSheet(_ picker: UIViewController) {
    if let sheet = picker.sheetPresentationController {
      sheet.detents = [.medium(), .large()]
      sheet.prefersGrabberVisible = true
      sheet.prefersScrollingExpandsWhenScrolledToEdge = true
      sheet.largestUndimmedDetentIdentifier = .medium
    }
    present(picker, animated: true) { [picker = picker] in
      if let presentationController = picker.presentationController {
        presentationController.delegate = self
      }
    }
  }
}

// MARK: - FloatingPanelControllerDelegate

extension DocumentSheetViewController: FloatingPanelControllerDelegate,
                                       UIAdaptivePresentationControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        if fpc.state == .hidden {
            fpc.dismiss(animated: false)
            isPresentingDocumentPicker = false
        }
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        isPresentingDocumentPicker = false
    }

    func floatingPanel(_ fpc: FloatingPanelController, contentOffsetForPinning trackedScrollView: UIScrollView) -> CGPoint {
        trackedScrollView.contentOffset
    }
}

// MARK: - FloatingPanel Layout

class DocumentPickerFloatingLayout: FloatingPanelLayout {
    var position: FloatingPanelPosition { .bottom }
    var initialState: FloatingPanelState { .half }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16, edge: .top, referenceGuide: .safeArea),
        ]
    }
}
