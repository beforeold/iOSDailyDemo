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

    // dump 所有实例方法（含父类可通过遍历层级获取）
    var current: AnyClass? = cls
    while let c = current {
        dumpMethods(of: c)
        current = class_getSuperclass(c)
        if let c = current, NSStringFromClass(c) == "NSObject" { break }
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
        print("[Hook] initWithSourceView: \(instance), sourceView: \(sourceView)")
        return instance
    }

    @objc func hook_setLargeBackground(_ background: AnyObject?) {
        let desc = background.map { "\(type(of: $0)): \($0)" } ?? "nil"
        print("[Hook] _setLargeBackground: \(desc)  (self: \(self))")
        hook_setLargeBackground(background)
    }

    @objc func hook_setNonLargeBackground(_ background: AnyObject?) {
        let desc = background.map { "\(type(of: $0)): \($0)" } ?? "nil"
        print("[Hook] _setNonLargeBackground: \(desc)  (self: \(self))")
        hook_setNonLargeBackground(background)
    }
}
