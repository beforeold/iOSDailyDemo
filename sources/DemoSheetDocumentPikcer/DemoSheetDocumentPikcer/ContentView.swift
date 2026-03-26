//
//  ContentView.swift
//  DemoSheetDocumentPikcer
//
//  Created by beforeold on 3/25/26.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers
import FloatingPanel

enum DocumentPickerPresenter {
    private static var isPresenting = false
    private static var floatingPanelDelegate: DocumentPickerFloatingPanelDelegate?

    static func present(onDismiss: (() -> Void)? = nil) {
        // 避免重复点击导致同时 present 多个 picker。
        guard !isPresenting, let presenter = topViewController() else { return }
        isPresenting = true

        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
        picker.allowsMultipleSelection = false
        picker.loadViewIfNeeded()
        picker.view.backgroundColor = .systemBackground

        let container = DocumentPickerPanelContainerViewController(picker: picker)

        let panel = FloatingPanelController()
        panel.set(contentViewController: container)
        panel.layout = DocumentPickerFloatingLayout()
        // 这里的行为参数是针对当前 demo 反复调出来的经验值，
        // 目标是让 full -> half 和 half -> hidden 的体感更接近系统 sheet。
        panel.behavior = DocumentPickerFloatingPanelBehavior()
        let delegate = DocumentPickerFloatingPanelDelegate {
            isPresenting = false
            floatingPanelDelegate = nil
            onDismiss?()
        }
        floatingPanelDelegate = delegate
        panel.delegate = delegate
        panel.isRemovalInteractionEnabled = true
        panel.contentMode = .fitToBounds
        panel.panGestureRecognizer.isEnabled = true
        panel.surfaceView.grabberHandle.isHidden = false
        panel.surfaceView.grabberHandlePadding = 12
        panel.surfaceView.appearance.cornerRadius = 16
        panel.loadViewIfNeeded()
        panel.view.layoutIfNeeded()

        presenter.present(panel, animated: true) {
            // 尝试把 picker 内部第一个 scrollView 交给 FloatingPanel 跟踪。
            // 受 UIDocumentPickerViewController 私有实现限制，内容区拖拽仍然不稳定，
            // 当前仍主要依赖顶部预留区域和显式关闭按钮。
            if let scrollView = container.firstScrollView(in: picker.viewIfLoaded) {
                panel.track(scrollView: scrollView)
            }
        }
    }

    private static func topViewController(
        from controller: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .rootViewController
    ) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(from: navigationController.visibleViewController)
        }

        if let tabBarController = controller as? UITabBarController {
            return topViewController(from: tabBarController.selectedViewController)
        }

        if let presentedViewController = controller?.presentedViewController {
            return topViewController(from: presentedViewController)
        }

        return controller
    }
}

final class DocumentPickerPanelContainerViewController: UIViewController {
    private let picker: UIViewController
    private let overlayView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let topGestureSpacerView = UIView()
    private var revealAttempts = 0

    init(picker: UIViewController) {
        self.picker = picker
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = resolvedBackgroundColor

        topGestureSpacerView.translatesAutoresizingMaskIntoConstraints = false
        // 这里保留一小段顶部空间，目的是放大 FloatingPanel 自身可拖拽区域。
        // 如果完全去掉，这个系统 picker 在内容区内几乎无法可靠触发 panel 高度变化。
        topGestureSpacerView.backgroundColor = resolvedBackgroundColor
        view.addSubview(topGestureSpacerView)

        addChild(picker)
        picker.view.translatesAutoresizingMaskIntoConstraints = false
        picker.view.alpha = 0
        view.addSubview(picker.view)
        picker.didMove(toParent: self)

        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = resolvedBackgroundColor
        view.addSubview(overlayView)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        overlayView.addSubview(activityIndicator)

        // FloatingPanel 初始布局阶段 surfaceView 可能瞬时高度为 0，
        // 这里用高优先级而不是 required，避免出现 Auto Layout warning。
        let topSpacerHeightConstraint = topGestureSpacerView.heightAnchor.constraint(equalToConstant: 28)
        topSpacerHeightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            topGestureSpacerView.topAnchor.constraint(equalTo: view.topAnchor),
            topGestureSpacerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topGestureSpacerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topSpacerHeightConstraint,
            picker.view.topAnchor.constraint(equalTo: topGestureSpacerView.bottomAnchor),
            picker.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picker.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            picker.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        revealPickerWhenReady()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyResolvedBackgroundColor()
    }

    private func revealPickerWhenReady() {
        revealAttempts += 1

        // Document Picker 首次构建内容有明显延迟。
        // 这里不是精确知道“何时完全 ready”，而是用一个足够实用的启发式判断，
        // 避免 panel 到达 medium 前出现整块空白。
        let isReady = picker.viewIfLoaded?.bounds.height ?? 0 > 0 && !(picker.viewIfLoaded?.subviews.isEmpty ?? true)
        guard !isReady, revealAttempts < 20 else {
            UIView.animate(withDuration: 0.2) {
                self.picker.view.alpha = 1
                self.overlayView.alpha = 0
            } completion: { _ in
                self.overlayView.removeFromSuperview()
            }
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            self?.revealPickerWhenReady()
        }
    }

    private var resolvedBackgroundColor: UIColor {
        UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .light {
                // light 模式下系统 picker 的最近项目页背景更接近 #FCFCFC，
                // 直接使用系统背景会出现轻微色差。
                return UIColor(red: 252.0 / 255.0, green: 252.0 / 255.0, blue: 252.0 / 255.0, alpha: 1)
            }
            return self.resolvedContentBackgroundColor(in: self.picker.viewIfLoaded) ?? .systemBackground
        }
    }

    private func applyResolvedBackgroundColor() {
        let color = resolvedBackgroundColor
        view.backgroundColor = color
        topGestureSpacerView.backgroundColor = color
        overlayView.backgroundColor = color
    }

    private func resolvedContentBackgroundColor(in view: UIView?) -> UIColor? {
        guard let view else { return nil }

        // dark 模式下尽量跟随 picker 内部真实背景色，而不是再硬编码一个近似值。
        if let scrollView = view as? UIScrollView,
           let color = resolvedOpaqueColor(from: scrollView.backgroundColor) {
            return color
        }

        if let color = resolvedOpaqueColor(from: view.backgroundColor) {
            return color
        }

        for subview in view.subviews {
            if let color = resolvedContentBackgroundColor(in: subview) {
                return color
            }
        }

        return nil
    }

    private func resolvedOpaqueColor(from color: UIColor?) -> UIColor? {
        guard let color else { return nil }
        if color.cgColor.alpha <= 0.01 {
            return nil
        }
        return color
    }

    func firstScrollView(in view: UIView?) -> UIScrollView? {
        guard let view else { return nil }
        if let scrollView = view as? UIScrollView {
            return scrollView
        }

        for subview in view.subviews {
            if let scrollView = firstScrollView(in: subview) {
                return scrollView
            }
        }
        return nil
    }
}

final class DocumentPickerFloatingPanelBehavior: NSObject, FloatingPanelBehavior {
    nonisolated var springDecelerationRate: CGFloat {
        UIScrollView.DecelerationRate.fast.rawValue + 0.001
    }

    nonisolated var springResponseTime: CGFloat {
        0.4
    }

    nonisolated var momentumProjectionRate: CGFloat {
        UIScrollView.DecelerationRate.normal.rawValue
    }

    nonisolated var removalInteractionVelocityThreshold: CGFloat {
        2.8
    }

    nonisolated func shouldProjectMomentum(_ fpc: FloatingPanelController, to proposedState: FloatingPanelState) -> Bool {
        // 允许 full 和 hidden 参与动量投射，但真正进入 hidden
        // 还要结合 delegate 里的更严格 remove 条件。
        proposedState == .full || proposedState == .hidden
    }

    nonisolated func redirectionalProgress(_ fpc: FloatingPanelController, from: FloatingPanelState, to: FloatingPanelState) -> CGFloat {
        switch (from, to) {
        case (.half, .hidden):
            return 0.18
        case (.half, .full):
            return 0.35
        default:
            return 0.5
        }
    }
}

final class DocumentPickerFloatingPanelDelegate: NSObject, FloatingPanelControllerDelegate {
    private let onDismiss: () -> Void

    init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }

    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        if fpc.state == .hidden {
            fpc.dismiss(animated: false)
            onDismiss()
        }
    }

    func floatingPanel(
        _ fpc: FloatingPanelController,
        contentOffsetForPinning trackedScrollView: UIScrollView
    ) -> CGPoint {
        trackedScrollView.contentOffset
    }

    func floatingPanel(
        _ fpc: FloatingPanelController,
        shouldAllowToScroll scrollView: UIScrollView,
        in state: FloatingPanelState
    ) -> Bool {
        // 当前只允许在 full 状态下滚动内容，
        // 这样 medium 状态下向上拖更容易先把 panel 拉大。
        state == .full
    }

    func floatingPanel(_ fpc: FloatingPanelController, shouldRemoveAt location: CGPoint, with velocity: CGVector) -> Bool {
        // 关闭手势只在 half 状态下生效，避免 full 状态下快速下拉直接 dismiss。
        // 这里的阈值同样是经验值：必须“快且深”才允许进入 hidden。
        guard fpc.state == .half, velocity.dy > 0 else { return false }
        let halfY = fpc.surfaceLocation(for: .half).y
        let fullY = fpc.surfaceLocation(for: .full).y
        let halfTravel = (halfY - fullY) / 2
        let removalThresholdY = halfY + halfTravel
        return velocity.dy > 2.2 && location.y > removalThresholdY
    }
}

struct DocumentBrowserView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIDocumentBrowserViewController {
        let browser = UIDocumentBrowserViewController(forOpening: [.item])
        browser.allowsDocumentCreation = false
        browser.allowsPickingMultipleItems = false
        return browser
    }

    func updateUIViewController(_ uiViewController: UIDocumentBrowserViewController, context: Context) {}
}

enum SheetType: Identifiable {
    case browser

    var id: Self { self }
}

struct DocumentSheetVCWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DocumentSheetViewController {
        DocumentSheetViewController()
    }
    func updateUIViewController(_ uiViewController: DocumentSheetViewController, context: Context) {}
}

struct PickerHitTestVCWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PickerHitTestViewController {
        PickerHitTestViewController()
    }
    func updateUIViewController(_ uiViewController: PickerHitTestViewController, context: Context) {}
}

struct ContentView: View {
    @State private var activeSheet: SheetType?
    @State private var isPresentingDocumentPicker = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button("Document Picker") {
                    isPresentingDocumentPicker = true
                    DocumentPickerPresenter.present {
                        isPresentingDocumentPicker = false
                    }
                }
                .disabled(isPresentingDocumentPicker)

                Button("Document Browser") {
                    activeSheet = .browser
                }

                NavigationLink("UIKit ViewController →") {
                    DocumentSheetVCWrapper()
                        .navigationTitle("UIKit Sheet")
                        .navigationBarTitleDisplayMode(.inline)
                        .ignoresSafeArea()
                }

                NavigationLink("Picker HitTest →") {
                    PickerHitTestVCWrapper()
                        .navigationTitle("Picker HitTest")
                        .navigationBarTitleDisplayMode(.inline)
                        .ignoresSafeArea()
                }
            }
            .font(.title2)
            .padding()
            .navigationTitle("SwiftUI Sheet")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $activeSheet) { type in
            switch type {
            case .browser:
                DocumentBrowserView()
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    ContentView()
}
