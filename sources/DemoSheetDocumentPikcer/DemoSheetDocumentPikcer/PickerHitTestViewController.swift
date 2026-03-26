//
//  PickerHitTestViewController.swift
//  DemoSheetDocumentPikcer
//

import UIKit
import UniformTypeIdentifiers

// MARK: - HitTestOverlayView

class HitTestOverlayView: UIView {
  var onHitTest: ((CGPoint) -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .gray.withAlphaComponent(0.1)
    isUserInteractionEnabled = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError() }

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let hit = super.hitTest(point, with: event)
    print("[HitTest] point=\(point)  hit=\(hit.map { "\(type(of: $0))" } ?? "nil")")
    onHitTest?(point)
    // 透传给下层 picker
    return nil
  }

  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let inside = super.point(inside: point, with: event)
    print("[PointInside] point=\(point)  inside=\(inside)")
    return inside
  }
}

// MARK: - PickerHitTestViewController

class PickerHitTestViewController: UIViewController {

  private let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio, .movie, .jpeg, .png])
  private let overlay = HitTestOverlayView()

  // picker 顶部位置约束，通过改变 constant 实现高度动画
  private var pickerTopConstraint: NSLayoutConstraint!
  private var isExpanded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Picker HitTest"
        view.backgroundColor = .systemBackground
        picker.delegate = self

        setupPicker()
        setupOverlay()

    overlay.onHitTest = { [weak self, weak overlay] point in
      guard let self, !self.isExpanded else { return }
       overlay?.removeFromSuperview()

      DispatchQueue.main.async {
        self.expandToFull()
      }
    }
  }

  // MARK: - Setup

  private func setupPicker() {
    addChild(picker)
    picker.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(picker.view)
    picker.didMove(toParent: self)

    // 初始从视图中间位置开始（半屏高度）
    // pickerTopConstraint = picker.view.topAnchor.constraint(equalTo: view.bottomAnchor, multiplier: 1)
    pickerTopConstraint = picker.view.topAnchor.constraint(equalTo: view.topAnchor, constant: halfOffset)

    NSLayoutConstraint.activate([
      pickerTopConstraint,
      picker.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      picker.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      picker.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  private var halfOffset: CGFloat {
    view.bounds.height > 0 ? view.bounds.height / 2 : UIScreen.main.bounds.height / 2
  }

  private func setupOverlay() {
    overlay.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(overlay)

    NSLayoutConstraint.activate([
      overlay.topAnchor.constraint(equalTo: picker.view.topAnchor),
      overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  // MARK: - Layout

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    // 首次 layout 完成后修正初始 offset
    if !isExpanded {
      pickerTopConstraint.constant = halfOffset
    }
  }

  // MARK: - Animation

    private func expandToFull() {
        isExpanded = true
        pickerTopConstraint.constant = 0
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.5
        ) {
            self.view.layoutIfNeeded()
        }
        print("[HitTest] 触发 expand → full")
    }
}

// MARK: - UIDocumentPickerDelegate

extension PickerHitTestViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("[Picker] 选中文件：")
        urls.forEach { print("  \($0.lastPathComponent)  →  \($0)") }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("[Picker] 用户取消选择")
    }
}
