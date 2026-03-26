//
//  UISheetPresentationControllerHook.swift
//  DemoSheetDocumentPikcer
//

import UIKit
import ObjectiveC

// MARK: - Method Dump

func dumpMethods(of cls: AnyClass) {
    var count: UInt32 = 0
    guard let methods = class_copyMethodList(cls, &count) else {
        print("[\(NSStringFromClass(cls))] 无方法列表")
        return
    }
    defer { free(methods) }

    print("========== \(NSStringFromClass(cls)) 方法列表（共 \(count) 个）==========")
    for i in 0..<Int(count) {
        let method = methods[i]
        let sel = method_getName(method)
        let typeEncoding = method_getTypeEncoding(method).map { String(cString: $0) } ?? "unknown"
        print("  [\(i)] \(NSStringFromSelector(sel))  ->  \(typeEncoding)")
    }
    print("==========================================================")
}

// MARK: - Swizzle Helper

private func swizzle(_ cls: AnyClass, original: Selector, swizzled: Selector) {
    guard
        let originalMethod = class_getInstanceMethod(cls, original),
        let swizzledMethod = class_getInstanceMethod(cls, swizzled)
    else {
        print("[Hook] swizzle 失败: \(NSStringFromSelector(original))")
        return
    }
    method_exchangeImplementations(originalMethod, swizzledMethod)
    print("[Hook] 已 hook: \(NSStringFromSelector(original))")
}

// MARK: - Swizzle Hook

private let swizzleOnce: Void = {
    guard let cls = NSClassFromString("UISheetPresentationController") else {
        print("[Hook] 未找到 UISheetPresentationController")
        return
    }

    swizzle(cls,
            original: NSSelectorFromString("initWithSourceView:"),
            swizzled: #selector(UISheetPresentationController.hook_initWithSourceView(_:)))

    swizzle(cls,
            original: NSSelectorFromString("_setLargeBackground:"),
            swizzled: #selector(UISheetPresentationController.hook_setLargeBackground(_:)))

    swizzle(cls,
            original: NSSelectorFromString("_setNonLargeBackground:"),
            swizzled: #selector(UISheetPresentationController.hook_setNonLargeBackground(_:)))
}()

// MARK: - Hook Entry

enum UISheetPresentationControllerHook {
    static func install() {
        _ = swizzleOnce
    }
}

// MARK: - Swizzled Implementation

extension UISheetPresentationController {
    @objc func hook_initWithSourceView(_ sourceView: UIView) -> UISheetPresentationController {
        let instance = hook_initWithSourceView(sourceView)
        instance.sanitizePresentationSurface()
        return instance
    }

    @objc func hook_setLargeBackground(_ background: AnyObject?) {
        sanitizePresentationSurface()
        hook_setLargeBackground(makeOpaqueBackground(from: background))
    }

    @objc func hook_setNonLargeBackground(_ background: AnyObject?) {
        sanitizePresentationSurface()
        hook_setNonLargeBackground(makeOpaqueBackground(from: background))
    }

    private func makeOpaqueBackground(from background: AnyObject?) -> AnyObject? {
        guard let view = background as? UIView else {
            return background
        }

        let replacement = UIView(frame: view.frame)
        replacement.backgroundColor = .systemBackground
        replacement.autoresizingMask = view.autoresizingMask
        replacement.layer.cornerRadius = view.layer.cornerRadius
        replacement.layer.cornerCurve = view.layer.cornerCurve
        replacement.layer.maskedCorners = view.layer.maskedCorners
        replacement.clipsToBounds = true
        return replacement
    }

    private func sanitizePresentationSurface() {
        backgroundEffect = nil

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            for key in ["_largeBackground", "_nonLargeBackground"] {
                guard let backgroundView = self.value(forKey: key) as? UIView else { continue }
                backgroundView.backgroundColor = .systemBackground
                self.clearVisualEffects(in: backgroundView)
            }

            if let containerView = self.containerView {
                containerView.backgroundColor = .clear
                self.clearVisualEffects(in: containerView)
            }

            if let presentedView = presentedViewController.viewIfLoaded {
                presentedView.backgroundColor = .systemBackground
                self.clearVisualEffects(in: presentedView)
            }
        }
    }

    private func clearVisualEffects(in view: UIView) {
        if let effectView = view as? UIVisualEffectView {
            effectView.effect = nil
            effectView.backgroundColor = .systemBackground
        } else if view.backgroundColor == nil {
            view.backgroundColor = .clear
        }

        for subview in view.subviews {
            clearVisualEffects(in: subview)
        }
    }
}
