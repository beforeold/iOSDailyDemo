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
        guard !isPresenting, let presenter = topViewController() else { return }
        isPresenting = true

        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
        picker.allowsMultipleSelection = false
        picker.overrideUserInterfaceStyle = presenter.traitCollection.userInterfaceStyle
        picker.loadViewIfNeeded()
        picker.view.backgroundColor = .systemBackground

        let container = DocumentPickerPanelContainerViewController(
            picker: picker,
            interfaceStyle: presenter.traitCollection.userInterfaceStyle
        )

        let panel = FloatingPanelController()
        panel.set(contentViewController: container)
        panel.layout = DocumentPickerFloatingLayout()
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

        presenter.present(panel, animated: true)
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
    private var revealAttempts = 0

    init(picker: UIViewController, interfaceStyle: UIUserInterfaceStyle) {
        self.picker = picker
        super.init(nibName: nil, bundle: nil)
        overrideUserInterfaceStyle = interfaceStyle
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        addChild(picker)
        picker.view.translatesAutoresizingMaskIntoConstraints = false
        picker.view.alpha = 0
        view.addSubview(picker.view)
        NSLayoutConstraint.activate([
            picker.view.topAnchor.constraint(equalTo: view.topAnchor),
            picker.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picker.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            picker.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        picker.didMove(toParent: self)

        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = .systemBackground
        view.addSubview(overlayView)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        overlayView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
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

    private func revealPickerWhenReady() {
        revealAttempts += 1

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
}

final class DocumentPickerFloatingPanelDelegate: NSObject, FloatingPanelControllerDelegate, UIGestureRecognizerDelegate {
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

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
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
