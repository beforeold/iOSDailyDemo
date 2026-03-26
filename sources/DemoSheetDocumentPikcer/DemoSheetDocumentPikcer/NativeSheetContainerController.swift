//
//  NativeSheetContainerController.swift
//  DemoSheetDocumentPikcer
//
//  自定义 bottom sheet 容器。
//
//  为什么不直接使用 UISheetPresentationController：
//  iOS 26 的 UISheetPresentationController 在 dark mode + medium detent 下，
//  会对 sheet 内容施加 elevated 材质（liquid glass）。
//  UIDocumentPickerViewController 的内容由远程进程渲染（_UIRemoteView），
//  traitOverrides.userInterfaceLevel = .base 无法穿透到远程视图，
//  导致内容颜色发灰且无法修复。
//
//  本方案将 picker 作为 child VC 嵌入，以 .overFullScreen 模态呈现，
//  不经过 UISheetPresentationController，从而避免 elevated 材质问题。
//  手动实现 medium/large 两档 detent、拖拽手势和 dismiss 动画。
//
//  拖拽区域说明：
//  picker 内容从 containerView 顶部偏移 dragAreaHeight（28pt）开始，
//  上方预留的空间（grabber + 空白）作为拖拽手柄区域。
//  此区域是本地视图，不涉及远程视图，UIPanGestureRecognizer 可直接响应触摸。
//  picker 内容区域由 _UIRemoteView 渲染，本地手势无法拦截其触摸事件，
//  因此内容区域的拖拽不由本容器处理。

import UIKit

final class NativeSheetContainerController: UIViewController {

    enum Detent: Equatable {
        case medium, large
    }

    // MARK: - Properties

    private let contentVC: UIViewController
    private let containerView = UIView()
    private let grabberView = UIView()
    private let dimmingView = UIView()

    private var containerTopConstraint: NSLayoutConstraint!
    private(set) var currentDetent: Detent = .medium

    /// picker 内部的 scrollView，拖拽 sheet 时需要锁定其 contentOffset 防止同时滚动。
    private weak var trackedScrollView: UIScrollView?
    private var isSheetDragging = false
    private var panStartConstraint: CGFloat = 0

    var onDismiss: (() -> Void)?

    /// 顶部拖拽区域高度，同时也是 picker 内容的 topAnchor 偏移量。
    private let dragAreaHeight: CGFloat = 28

    // MARK: - Computed layout values

    private var mediumTop: CGFloat {
        view.bounds.height * 0.5
    }

    private var largeTop: CGFloat {
        view.safeAreaInsets.top + 44
    }

    // MARK: - Init

    init(content: UIViewController) {
        self.contentVC = content
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        setupDimmingView()
        setupContainer()
        setupGrabber()
        embedContent()
        setupPanGesture()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 统一处理所有 dismiss 路径：
        // - 拖拽手势关闭
        // - 点击 dimming 背景关闭
        // - picker 内部关闭按钮（会直接 dismiss 最近的 presented VC）
        onDismiss?()
        onDismiss = nil
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // UIDocumentPickerViewController 首次构建内容有明显延迟，
        // 需要等待 view hierarchy 建立后才能找到内部 scrollView。
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }
            self.trackedScrollView = self.findFirstScrollView(in: self.contentVC.view)
        }

        // 初始在屏幕外，动画滑入 medium 位置
        containerTopConstraint.constant = mediumTop
        UIView.animate(
            withDuration: 0.45,
            delay: 0,
            usingSpringWithDamping: 0.88,
            initialSpringVelocity: 0
        ) {
            self.dimmingView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Setup

    private func setupDimmingView() {
        // dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        dimmingView.alpha = 0
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimmingView)
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        dimmingView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
        )
    }

    private func setupContainer() {
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        // 初始 constant = view.bounds.height，即在屏幕外
        containerTopConstraint = containerView.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: view.bounds.height
        )
        NSLayoutConstraint.activate([
            containerTopConstraint,
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupGrabber() {
        grabberView.backgroundColor = UIColor.label.withAlphaComponent(0.3)
        grabberView.layer.cornerRadius = 2.5
        grabberView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(grabberView)
        NSLayoutConstraint.activate([
            grabberView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            grabberView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            grabberView.widthAnchor.constraint(equalToConstant: 36),
            grabberView.heightAnchor.constraint(equalToConstant: 5),
        ])
    }

    private func embedContent() {
        addChild(contentVC)
        contentVC.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(contentVC.view)
        NSLayoutConstraint.activate([
            contentVC.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: dragAreaHeight),
            contentVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        contentVC.didMove(toParent: self)
    }

    private func setupPanGesture() {
        // pan gesture 加在 containerView 上。
        // 顶部 dragAreaHeight 区域是本地视图（grabber + 空白），可正常接收触摸。
        // picker 内容区域的触摸由 _UIRemoteView 在远程进程处理，不会到达此手势。
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        containerView.addGestureRecognizer(pan)
    }

    // MARK: - Pan Gesture Handler

    @objc private func handlePan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: view)
        let velocity = pan.velocity(in: view)

        switch pan.state {
        case .began:
            panStartConstraint = containerTopConstraint.constant
            isSheetDragging = true

        case .changed:
            guard isSheetDragging else { return }

            let proposedTop = panStartConstraint + translation.y

            // 超过 large 位置时施加橡皮筋阻力，防止无限上拉
            if proposedTop < largeTop {
                let overscroll = largeTop - proposedTop
                containerTopConstraint.constant = largeTop - rubberBand(overscroll, dimension: 300)
            } else {
                containerTopConstraint.constant = proposedTop
            }

            // 拖拽 sheet 期间锁定 scroll view，避免内容同时滚动
            pinScrollViewToTop()

        case .ended, .cancelled:
            guard isSheetDragging else {
                isSheetDragging = false
                return
            }
            isSheetDragging = false

            let currentTop = containerTopConstraint.constant

            // 根据松手时的速度和位置决定目标 detent 或 dismiss
            if velocity.y > 800 && currentDetent == .medium {
                dismissSheet()
            } else if velocity.y > 1500 {
                dismissSheet()
            } else if velocity.y > 500 && currentDetent == .large {
                animateToDetent(.medium)
            } else if velocity.y < -500 {
                animateToDetent(.large)
            } else if currentTop > mediumTop + (view.bounds.height - mediumTop) * 0.35 {
                dismissSheet()
            } else {
                // 吸附到最近的 detent
                let distToMedium = abs(currentTop - mediumTop)
                let distToLarge = abs(currentTop - largeTop)
                animateToDetent(distToLarge < distToMedium ? .large : .medium)
            }

        default:
            break
        }
    }

    // MARK: - Animations

    private func animateToDetent(_ detent: Detent) {
        currentDetent = detent
        containerTopConstraint.constant = detent == .medium ? mediumTop : largeTop

        UIView.animate(
            withDuration: 0.45,
            delay: 0,
            usingSpringWithDamping: 0.88,
            initialSpringVelocity: 0
        ) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func dismissSheet() {
        containerTopConstraint.constant = view.bounds.height
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.dimmingView.alpha = 0
                self.view.layoutIfNeeded()
            }
        ) { _ in
            self.dismiss(animated: false)
            // onDismiss 由 viewDidDisappear 统一触发，无需在此调用
        }
    }

    // MARK: - Helpers

    /// 模拟 UIScrollView 的橡皮筋回弹效果
    private func rubberBand(_ offset: CGFloat, dimension: CGFloat) -> CGFloat {
        let c: CGFloat = 0.55
        return (1.0 - (1.0 / ((offset * c / dimension) + 1.0))) * dimension
    }

    private func pinScrollViewToTop() {
        guard let sv = trackedScrollView else { return }
        sv.contentOffset.y = -(sv.adjustedContentInset.top)
    }

    private func findFirstScrollView(in view: UIView) -> UIScrollView? {
        if let sv = view as? UIScrollView { return sv }
        for sub in view.subviews {
            if let found = findFirstScrollView(in: sub) { return found }
        }
        return nil
    }
}

// MARK: - UIGestureRecognizerDelegate

extension NativeSheetContainerController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        let velocity = pan.velocity(in: view)
        // 只响应垂直方向的拖拽，避免与水平滑动冲突
        return abs(velocity.y) > abs(velocity.x)
    }
}
