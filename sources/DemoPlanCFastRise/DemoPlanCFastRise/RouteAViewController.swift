import UIKit
import FloatingPanel

/// 路线 A：保留 FloatingPanel 自带 pan（1:1 跟手），
///        让 surface 透明 + 不裁剪；PlayerContentView 自己以 N 倍速「向上溢出 surface」生长。
///
/// 用户视觉上看到的「PlayerView 顶边」= content.frame.top，
/// 它在前 150pt 手势距离内就到达屏幕顶；之后 surface 继续 1:1 长高到全屏，content 维持终态。
final class RouteAViewController: UIViewController {

  private let fpc = FloatingPanelController()
  private let content = PlayerContentView()
  private let backgroundList = makeBackgroundList(title: "Route A · FP + 子视图溢出")

  /// 视觉转场距离：手势距离 surface 长高 = transitionDistance 时，content 已经长到 full
  private let transitionDistance: CGFloat = 150

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupBackgroundList()
    setupPanel()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    fpc.addPanel(toParent: self, animated: false)
    // 把 content 直接挂到 surfaceView 上（不放在 contentVC.view 里，避免 Auto Layout 干扰）
    fpc.surfaceView.addSubview(content)
    DispatchQueue.main.async { [weak self] in self?.layoutContent() }
    setupDebugButtons()
  }

  private func setupDebugButtons() {
    let toFull = UIButton(type: .system)
    toFull.setTitle("→ full", for: .normal)
    toFull.titleLabel?.font = .systemFont(ofSize: 13)
    toFull.backgroundColor = .systemBlue.withAlphaComponent(0.2)
    toFull.layer.cornerRadius = 8
    toFull.addAction(UIAction { [weak self] _ in self?.fpc.move(to: .full, animated: true) { self?.layoutContent() } }, for: .touchUpInside)
    toFull.translatesAutoresizingMaskIntoConstraints = false

    let toTip = UIButton(type: .system)
    toTip.setTitle("→ tip", for: .normal)
    toTip.titleLabel?.font = .systemFont(ofSize: 13)
    toTip.backgroundColor = .systemGray.withAlphaComponent(0.2)
    toTip.layer.cornerRadius = 8
    toTip.addAction(UIAction { [weak self] _ in self?.fpc.move(to: .tip, animated: true) { self?.layoutContent() } }, for: .touchUpInside)
    toTip.translatesAutoresizingMaskIntoConstraints = false

    let stack = UIStackView(arrangedSubviews: [toFull, toTip])
    stack.axis = .horizontal
    stack.spacing = 8
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
      stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      toFull.widthAnchor.constraint(equalToConstant: 70),
      toFull.heightAnchor.constraint(equalToConstant: 32),
      toTip.widthAnchor.constraint(equalToConstant: 70),
    ])
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    layoutContent()
  }

  private func setupBackgroundList() {
    backgroundList.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(backgroundList)
    NSLayoutConstraint.activate([
      backgroundList.topAnchor.constraint(equalTo: view.topAnchor),
      backgroundList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      backgroundList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      backgroundList.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  private func setupPanel() {
    fpc.delegate = self
    fpc.layout = MiniFullLayout()
    fpc.behavior = SnappyBehavior()
    fpc.isRemovalInteractionEnabled = false

    // surface 完全隐身（由 content 承担视觉）
    fpc.surfaceView.appearance.backgroundColor = .clear
    fpc.surfaceView.appearance.cornerRadius = 0
    fpc.surfaceView.appearance.shadows = []
    fpc.surfaceView.backgroundColor = .clear
    fpc.surfaceView.grabberHandle.isHidden = true
    fpc.surfaceView.clipsToBounds = false
    fpc.surfaceView.containerView.clipsToBounds = false
    fpc.surfaceView.containerView.layer.masksToBounds = false

    // 占位 contentVC：FP 需要一个 content，但我们不让它显示什么
    fpc.contentMode = .fitToBounds
    let placeholder = UIView()
    placeholder.backgroundColor = .clear
    placeholder.isUserInteractionEnabled = false
    let dummyVC = UIViewController()
    dummyVC.view = placeholder
    fpc.set(contentViewController: dummyVC)
  }

  /// 在 didMove / didLayout 时调用
  private func layoutContent() {
    let surface = fpc.surfaceView
    let surfaceHeight = surface.bounds.height
    let miniHeight: CGFloat = 72

    // surface 已上升的距离（最大值 = 屏幕高 - miniHeight）
    let raised = max(0, surfaceHeight - miniHeight)

    // 视觉 progress：surface 长高前 transitionDistance 内 → 0..1，之后 clamp 到 1
    let visualProgress = min(raised / transitionDistance, 1)

    // content 的可见高度：mini 时 = miniHeight，full 时 = 屏幕高
    let fullHeight = view.bounds.height
    let contentHeight = miniHeight + (fullHeight - miniHeight) * visualProgress

    // content 锚定在 surface 底部，向上生长（溢出 surface 顶部时 origin.y < 0）
    let newFrame = CGRect(
      x: 0,
      y: surfaceHeight - contentHeight,
      width: surface.bounds.width,
      height: contentHeight,
    )
    content.frame = newFrame
    content.apply(progress: visualProgress)
  }
}

extension RouteAViewController: FloatingPanelControllerDelegate {
  func floatingPanelDidMove(_ fpc: FloatingPanelController) {
    print("[A] didMove surface.frame=\(fpc.surfaceView.frame)")
    layoutContent()
  }
  func floatingPanelDidEndAttracting(_ fpc: FloatingPanelController) {
    layoutContent()
  }
  func floatingPanelWillBeginDragging(_ fpc: FloatingPanelController) {
    print("[A] willBeginDragging")
  }
}

// MARK: - Layout/Behavior shared

final class MiniFullLayout: FloatingPanelLayout {
  var position: FloatingPanelPosition { .bottom }
  var initialState: FloatingPanelState { .tip }
  var anchors: [FloatingPanelState: any FloatingPanelLayoutAnchoring] {
    [
      .tip: FloatingPanelLayoutAnchor(absoluteInset: 72, edge: .bottom, referenceGuide: .superview),
      .full: FloatingPanelLayoutAnchor(absoluteInset: 0, edge: .top, referenceGuide: .superview),
    ]
  }
}

final class SnappyBehavior: FloatingPanelBehavior {
  var springDecelerationRate: CGFloat { UIScrollView.DecelerationRate.normal.rawValue }
  var springResponseTime: CGFloat { 0.3 }
  var momentumProjectionRate: CGFloat { 0.95 }
}

// MARK: - 背景列表（demo 仅展示）

func makeBackgroundList(title: String) -> UIView {
  let v = UIView()
  v.backgroundColor = .systemGroupedBackground
  let label = UILabel()
  label.text = title + "\n\n下方 minibar 上滑\n手指 0→150pt 内完成 tip→full"
  label.numberOfLines = 0
  label.textAlignment = .center
  label.font = .preferredFont(forTextStyle: .body)
  label.textColor = .secondaryLabel
  label.translatesAutoresizingMaskIntoConstraints = false
  v.addSubview(label)
  NSLayoutConstraint.activate([
    label.centerXAnchor.constraint(equalTo: v.centerXAnchor),
    label.centerYAnchor.constraint(equalTo: v.centerYAnchor, constant: -80),
    label.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 24),
    label.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -24),
  ])
  return v
}
