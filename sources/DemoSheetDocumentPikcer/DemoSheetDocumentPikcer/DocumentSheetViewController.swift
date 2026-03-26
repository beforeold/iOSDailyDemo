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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addChild(childVC)
        childVC.view.frame = view.bounds
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(childVC.view)
        childVC.didMove(toParent: self)
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

    let container = SheetContainerViewController(child: picker)
    container.disableGlassEffect = true

    presentAsSheet(picker)
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

  // MARK: - Sheet Presentation

  private func presentAsSheet(_ picker: UIViewController) {
    if let sheet = picker.sheetPresentationController {
      sheet.detents = [.medium(), .large()]
      sheet.prefersGrabberVisible = true
      sheet.prefersScrollingExpandsWhenScrolledToEdge = true
      sheet.largestUndimmedDetentIdentifier = .medium
      sheet.traitOverrides.userInterfaceLevel = .base

      sheet.backgroundEffect = UIColorEffect(color: .red)
    }
    present(picker, animated: true) { [picker = picker] in
      if let presentationController = picker.presentationController {
        presentationController.traitOverrides.userInterfaceLevel = .base
        presentationController.delegate = self
      }

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
                                       UIGestureRecognizerDelegate,
                                       UIAdaptivePresentationControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        if fpc.state == .hidden {
            removeTouchObserver()
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

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
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
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16, edge: .top, referenceGuide: .safeArea),
        ]
    }
}
