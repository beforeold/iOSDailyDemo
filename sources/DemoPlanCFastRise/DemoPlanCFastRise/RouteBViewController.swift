import UIKit
import FloatingPanel

/// 路线 B：禁用 FloatingPanel 自带 pan，自己接管 pan；
///        手势位移按 1:N 直接调整 surfaceView.frame（surface 真的快速到顶）；
///        松手时调 fpc.move(to:animated:) 把 state 切到 tip / full（FP 接管吸附动画）。
final class RouteBViewController: UIViewController {

  private let fpc = FloatingPanelController()
  private let content = PlayerContentView()
  private let backgroundList = makeBackgroundList(title: "Route B · 禁用 FP pan + 自定义 1:N")

  private let transitionDistance: CGFloat = 150

  private lazy var pan: UIPanGestureRecognizer = {
    let g = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    g.maximumNumberOfTouches = 1
    return g
  }()

  /// 拖动开始时 surfaceView.origin.y 的快照
  private var dragStartOriginY: CGFloat = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupBackgroundList()
    setupPanel()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    fpc.addPanel(toParent: self, animated: false)
    fpc.surfaceView.addSubview(content)
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      self.fpc.panGestureRecognizer.isEnabled = false
      self.fpc.surfaceView.addGestureRecognizer(self.pan)
      self.layoutContent()
    }
    setupDebugButtons()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    layoutContent()
  }

  private func setupDebugButtons() {
    let toFull = UIButton(type: .system)
    toFull.setTitle("→ full", for: .normal)
    toFull.titleLabel?.font = .systemFont(ofSize: 13)
    toFull.backgroundColor = .systemBlue.withAlphaComponent(0.2)
    toFull.layer.cornerRadius = 8
    toFull.addAction(UIAction { [weak self] _ in
      self?.fpc.move(to: .full, animated: true) { self?.layoutContent() }
    }, for: .touchUpInside)

    let toTip = UIButton(type: .system)
    toTip.setTitle("→ tip", for: .normal)
    toTip.titleLabel?.font = .systemFont(ofSize: 13)
    toTip.backgroundColor = .systemGray.withAlphaComponent(0.2)
    toTip.layer.cornerRadius = 8
    toTip.addAction(UIAction { [weak self] _ in
      self?.fpc.move(to: .tip, animated: true) { self?.layoutContent() }
    }, for: .touchUpInside)

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
    fpc.contentMode = .fitToBounds

    fpc.surfaceView.appearance.backgroundColor = .clear
    fpc.surfaceView.appearance.cornerRadius = 0
    fpc.surfaceView.appearance.shadows = []
    fpc.surfaceView.backgroundColor = .clear
    fpc.surfaceView.grabberHandle.isHidden = true
    fpc.surfaceView.clipsToBounds = false
    fpc.surfaceView.containerView.clipsToBounds = false
    fpc.surfaceView.containerView.layer.masksToBounds = false

    let placeholder = UIView()
    placeholder.backgroundColor = .clear
    placeholder.isUserInteractionEnabled = false
    let dummyVC = UIViewController()
    dummyVC.view = placeholder
    fpc.set(contentViewController: dummyVC)
  }

  // MARK: - 1:N 手势处理

  @objc private func handlePan(_ g: UIPanGestureRecognizer) {
    let parent = view!
    let parentHeight = parent.bounds.height
    let miniSurfaceTop = parentHeight - 72
    let fullSurfaceTop: CGFloat = 0
    let totalSurfaceTravel = miniSurfaceTop - fullSurfaceTop // 例 800pt

    // 1:N 速率
    let rate = totalSurfaceTravel / transitionDistance

    switch g.state {
    case .began:
      // 取消 FP 内部的 attractor 动画
      fpc.surfaceView.layer.removeAllAnimations()
      dragStartOriginY = fpc.surfaceView.frame.origin.y

    case .changed:
      let dy = g.translation(in: parent).y
      // 手指上滑 dy<0 → surface origin.y 应减小 |dy*rate|
      var targetY = dragStartOriginY + dy * rate
      targetY = max(fullSurfaceTop, min(miniSurfaceTop, targetY))
      var frame = fpc.surfaceView.frame
      frame.origin.y = targetY
      frame.size.height = parentHeight - targetY
      fpc.surfaceView.frame = frame
      layoutContent()

    case .ended, .cancelled, .failed:
      let velocity = g.velocity(in: parent).y
      let progress = currentVisualProgress()
      let snapToFull: Bool
      let threshold: CGFloat = 600
      if velocity < -threshold { snapToFull = true }
      else if velocity > threshold { snapToFull = false }
      else { snapToFull = progress >= 0.5 }

      // 让 FP 接管吸附动画
      fpc.move(to: snapToFull ? .full : .tip, animated: true) { [weak self] in
        self?.layoutContent()
      }

    default: break
    }
  }

  private func currentVisualProgress() -> CGFloat {
    let parentHeight = view.bounds.height
    let miniSurfaceTop = parentHeight - 72
    let now = fpc.surfaceView.frame.origin.y
    let traveled = miniSurfaceTop - now
    return max(0, min(1, traveled / transitionDistance))
  }

  private func layoutContent() {
    let surface = fpc.surfaceView
    // 路线 B：content 高度始终 = surface 高度（surface 自己快速到顶，content 跟着）
    content.frame = surface.bounds
    content.apply(progress: currentVisualProgress())
  }
}

extension RouteBViewController: FloatingPanelControllerDelegate {
  func floatingPanelDidMove(_ fpc: FloatingPanelController) {
    layoutContent()
  }
  func floatingPanelDidEndAttracting(_ fpc: FloatingPanelController) {
    layoutContent()
  }
}
