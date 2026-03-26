//
//  UIApplicationTouchHook.swift
//  DemoSheetDocumentPikcer
//

import UIKit
import ObjectiveC

// MARK: - UIApplicationTouchHook

enum UIApplicationTouchHook {
    static var onTouchBegan: ((UITouch) -> Void)?

    private static let install: Void = {
        let windowSel = #selector(UIWindow.sendEvent(_:))
        let windowHookSel = #selector(UIWindow.hook_window_sendEvent(_:))
        if let orig = class_getInstanceMethod(UIWindow.self, windowSel),
           let hook = class_getInstanceMethod(UIWindow.self, windowHookSel) {
            method_exchangeImplementations(orig, hook)
            print("[UIApplicationTouchHook] UIWindow.sendEvent 已 hook")
        }

        let appSel = #selector(UIApplication.sendEvent(_:))
        let appHookSel = #selector(UIApplication.hook_app_sendEvent(_:))
        if let orig = class_getInstanceMethod(UIApplication.self, appSel),
           let hook = class_getInstanceMethod(UIApplication.self, appHookSel) {
            method_exchangeImplementations(orig, hook)
            print("[UIApplicationTouchHook] UIApplication.sendEvent 已 hook")
        }
    }()

    static func setup() {
        _ = install
    }
}

// MARK: - UIWindow Swizzle

extension UIWindow {
    @objc func hook_window_sendEvent(_ event: UIEvent) {
        if event.type == .touches {
            event.allTouches?
                .filter { $0.phase == .began }
                .forEach { touch in
                    print("[UIWindowHook] touchBegan in window: \(type(of: self))")
                    UIApplicationTouchHook.onTouchBegan?(touch)
                }
        }
        hook_window_sendEvent(event)
    }
}

// MARK: - UIApplication Swizzle

extension UIApplication {
    @objc func hook_app_sendEvent(_ event: UIEvent) {
        if event.type == .touches {
            event.allTouches?
                .filter { $0.phase == .began }
                .forEach { touch in
                    print("[UIApplicationHook] touchBegan")
                    UIApplicationTouchHook.onTouchBegan?(touch)
                }
        }
        hook_app_sendEvent(event)
    }
}
