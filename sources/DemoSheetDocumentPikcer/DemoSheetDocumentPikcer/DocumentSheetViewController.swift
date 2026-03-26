//
//  DocumentSheetViewController.swift
//  DemoSheetDocumentPikcer
//

import UIKit
import UniformTypeIdentifiers
import FloatingPanel

// MARK: - Container VC

class SheetContainerViewController: UIViewController {
    private let childVC: UIViewController
    var disableGlassEffect = false

    init(child: UIViewController) {
        self.childVC = child
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private let overlay = HitTestOverlayView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addChild(childVC)
        childVC.view.frame = view.bounds
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(childVC.view)
        childVC.didMove(toParent: self)

        setupOverlay()
    }

    private func setupOverlay() {
        overlay.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlay)
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        overlay.onHitTest = { [weak self] _ in
            guard let self else { return }
            // 立即移除 overlay，不等下一个 runloop，本次触摸透传给 picker
            self.overlay.removeFromSuperview()
            // 切换到 large detent
            self.sheetPresentationController?.animateChanges {
                self.sheetPresentationController?.selectedDetentIdentifier = .large
            }
            print("[Container] HitTest 触发 → overlay 移除，切换 large")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if disableGlassEffect {
            removeGlassEffect()
        }
    }

    private func removeGlassEffect() {
        guard let sheet = sheetPresentationController else {
            print("[GlassEffect] sheetPresentationController not found")
            return
        }

        // 方案一：公开 API，设置 backgroundEffect 为 nil 去掉 blur
        sheet.backgroundEffect = nil
        print("[GlassEffect] backgroundEffect → nil")

        // 方案二：KVC 替换私有背景 view（兼容 iOS 18 以下）
        for key in ["_largeBackground", "_nonLargeBackground"] {
            if let old = sheet.value(forKey: key) as? UIView {
                let replacement = UIView()
                replacement.backgroundColor = .systemBackground
                replacement.frame = old.frame
                replacement.autoresizingMask = old.autoresizingMask
                sheet.setValue(replacement, forKey: key)
                print("[GlassEffect] KVC \(key) replaced: \(type(of: old))")
            } else {
                print("[GlassEffect] KVC \(key) not found")
            }
        }

        // 方案三：遍历容器视图，找到所有 UIVisualEffectView 并清除 effect
        if let containerView = sheet.containerView {
            removeVisualEffects(in: containerView)
        }
    }

    private func removeVisualEffects(in view: UIView, depth: Int = 0) {
        if let effectView = view as? UIVisualEffectView {
            effectView.effect = nil
            print("[GlassEffect] UIVisualEffectView.effect = nil at depth \(depth): \(effectView)")
        }
        for sub in view.subviews {
            removeVisualEffects(in: sub, depth: depth + 1)
        }
    }
}

// MARK: - DocumentSheetViewController

class DocumentSheetViewController: UIViewController {

  // MARK: - UI

  private lazy var sheetPickerButton: UIButton = makeButton(
    title: "UISheet Picker",
    color: .systemOrange,
    action: #selector(showSheetPicker)
  )

  private lazy var pickerContainerButton: UIButton = makeButton(
    title: "Picker in Container",
    color: .systemBlue,
    action: #selector(showPickerInContainer)
  )

  private lazy var browserButton: UIButton = makeButton(
    title: "Document Browser",
    color: .systemPurple,
    action: #selector(showBrowser)
  )

  private lazy var floatingPanelButton: UIButton = makeButton(
    title: "FloatingPanel Picker",
    color: .systemGreen,
    action: #selector(showFloatingPanelPicker)
  )

  private func makeButton(title: String, color: UIColor, action: Selector) -> UIButton {
    var config = UIButton.Configuration.filled()
    config.title = title
    config.baseBackgroundColor = color
    config.cornerStyle = .medium
    let btn = UIButton(configuration: config)
    btn.addTarget(self, action: action, for: .touchUpInside)
    return btn
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "UIKit Sheet"
    view.backgroundColor = .systemBackground

    let stack = UIStackView(arrangedSubviews: [sheetPickerButton, pickerContainerButton, browserButton, floatingPanelButton])
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

  @objc private func showPickerInContainer() {
    let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
    picker.allowsMultipleSelection = true

    let container = NativeSheetContainerController(content: picker)

    presentAsSheet(container)
  }

  @objc private func showBrowser() {
    let browser = UIDocumentBrowserViewController(forOpening: [.item])
    browser.allowsDocumentCreation = false
    browser.allowsPickingMultipleItems = true
    browser.delegate = self
    presentAsSheet(browser) { [weak browser] in
      guard let browser else { return }

      browser.view.backgroundColor = .clear

      // 方案一：私有 API 直接设置 editing mode
      let selectors = ["_enterSelectionMode", "setEditing:", "_setMode:"]
      for selName in selectors {
        let sel = NSSelectorFromString(selName)
        if browser.responds(to: sel) {
          print("[Browser] 找到私有方法: \(selName)")
          if selName == "setEditing:" {
            browser.perform(sel, with: true)
          } else {
            browser.perform(sel)
          }
          return
        }
      }

      // 方案二：遍历导航栏 barButtonItems，找 "Select" 按钮并触发
      print("[Browser] 私有方法未找到，尝试查找 Select 按钮")
      Self.triggerSelectButton(in: browser)
    }
  }

  private static func triggerSelectButton(in browser: UIDocumentBrowserViewController) {
    // dump browser 的方法列表，辅助找私有 API
    dumpMethods(of: type(of: browser))

    // 遍历所有 child VC 的导航栏找 Select 按钮
    func findAndTap(in vc: UIViewController) -> Bool {
      let allItems = (vc.navigationItem.rightBarButtonItems ?? [])
                   + (vc.navigationItem.leftBarButtonItems ?? [])
      for item in allItems {
        let title = item.title ?? ""
        let action = item.action.map { NSStringFromSelector($0) } ?? ""
        print("[Browser] barButtonItem title=\(title)  action=\(action)  target=\(String(describing: item.target))")
        if title.lowercased().contains("select") || action.lowercased().contains("select") {
          _ = item.target?.perform(item.action)
          print("[Browser] 触发 Select 按钮")
          return true
        }
      }
      for child in vc.children {
        if findAndTap(in: child) { return true }
      }
      return false
    }

    if !findAndTap(in: browser) {
      print("[Browser] 未找到 Select 按钮")
    }
  }

  @objc private func showFloatingPanelPicker() {
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
    fpc.panGestureRecognizer.isEnabled = false

    present(fpc, animated: true) { [weak fpc] in
      guard let fpc else { return }
      UIApplicationTouchHook.onTouchBegan = { [weak fpc] touch in
        guard let fpc, fpc.state != .full else { return }
        print("[FloatingPanel] onTouchBegan fired, fpc.state=\(fpc.state)")
        DispatchQueue.main.async {
          fpc.move(to: .full, animated: true)
          print("[FloatingPanel] → full")
        }
      }
    }
  }

  private func removeTouchObserver() {
    UIApplicationTouchHook.onTouchBegan = nil
  }

  @objc private func showSheetPicker() {
    let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
    picker.allowsMultipleSelection = false
    picker.delegate = self

    presentAsSheet(picker)
  }

  // MARK: - Sheet Presentation

  private func presentAsSheet(_ picker: UIViewController, completion: (() -> Void)? = nil) {
    if let sheet = picker.sheetPresentationController {
      sheet.detents = [.medium(), .large()]
      sheet.prefersGrabberVisible = true
      sheet.prefersScrollingExpandsWhenScrolledToEdge = true
      sheet.largestUndimmedDetentIdentifier = .medium
      sheet.traitOverrides.userInterfaceLevel = .elevated
    }
    picker.traitOverrides.userInterfaceLevel = .elevated
    present(picker, animated: true) { [picker = picker] in
      completion?()

      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        print("[presentAsSheet] 1s 后触发")
        Self.dumpChildVCs(picker, depth: 0)
      }
    }
  }

  private static func dumpChildVCs(_ vc: UIViewController, depth: Int) {
    let indent = String(repeating: "  ", count: depth)
    let view = vc.viewIfLoaded
    let viewInfo: String
    if let v = view {
      let size = v.bounds.size
      viewInfo = "view=\(type(of: v)) (\(Int(size.width))×\(Int(size.height)))"
    } else {
      viewInfo = "view=not loaded"
    }
    print("\(indent)[\(depth)] \(type(of: vc))  \(viewInfo)")
    for child in vc.children {
      dumpChildVCs(child, depth: depth + 1)
    }
  }

  private static func colorizeViews(_ view: UIView, depth: Int) {
    view.backgroundColor = .random
    let indent = String(repeating: "  ", count: depth)
    print("\(indent)[\(depth)] \(type(of: view)) → \(view.backgroundColor!)")
    for subview in view.subviews {
      colorizeViews(subview, depth: depth + 1)
    }
  }
}

// MARK: - FloatingPanelControllerDelegate

extension DocumentSheetViewController: FloatingPanelControllerDelegate,
                                       UIGestureRecognizerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        if fpc.state == .hidden {
            removeTouchObserver()
            fpc.dismiss(animated: false)
        }
    }

    func floatingPanel(_ fpc: FloatingPanelController, contentOffsetForPinning trackedScrollView: UIScrollView) -> CGPoint {
        trackedScrollView.contentOffset
    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}

// MARK: - UIDocumentBrowserViewControllerDelegate

extension DocumentSheetViewController: UIDocumentBrowserViewControllerDelegate {

    func documentBrowser(
        _ controller: UIDocumentBrowserViewController,
        didPickDocumentsAt documentURLs: [URL]
    ) {
        print("[Browser] 选中文件（\(documentURLs.count) 个）：")
        documentURLs.forEach { print("  \($0.lastPathComponent)  →  \($0)") }
        controller.dismiss(animated: true)
    }

    func documentBrowser(
        _ controller: UIDocumentBrowserViewController,
        didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void
    ) {
        print("[Browser] 请求创建文档")
        importHandler(nil, .none)
    }

    func documentBrowser(
        _ controller: UIDocumentBrowserViewController,
        didImportDocumentAt sourceURL: URL,
        toDestinationURL destinationURL: URL
    ) {
        print("[Browser] 导入完成: \(sourceURL.lastPathComponent) → \(destinationURL)")
    }

    func documentBrowser(
        _ controller: UIDocumentBrowserViewController,
        failedToImportDocumentAt documentURL: URL,
        error: (any Error)?
    ) {
        let msg = error?.localizedDescription ?? "未知错误"
        print("[Browser] 导入失败: \(documentURL.lastPathComponent)  error=\(msg)")
    }
}

// MARK: - UIDocumentPickerDelegate

extension DocumentSheetViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("[SheetPicker] 选中文件（\(urls.count) 个）：")
        urls.forEach { print("  \($0.lastPathComponent)  →  \($0)") }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("[SheetPicker] 用户取消")
    }
}

// MARK: - UIColor Random

extension UIColor {
    static var random: UIColor {
        UIColor(
            red: .random(in: 0.3...1),
            green: .random(in: 0.3...1),
            blue: .random(in: 0.3...1),
            alpha: 0.5
        )
    }
}

// MARK: - FloatingPanel Layout

class DocumentPickerFloatingLayout: FloatingPanelLayout {
    var position: FloatingPanelPosition { .bottom }
    var initialState: FloatingPanelState { .half }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .full: FloatingPanelLayoutAnchor(fractionalInset: 1.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
