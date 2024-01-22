//
//  TestUiPresentationApp.swift
//  TestUiPresentation
//
//  Created by Brook_Mobius on 1/22/24.
//

import SwiftUI
import UIKit

@main
struct TestUiPresentationApp: App {
  init() {
    self.setup()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }

  private func setup() {
//    NSObject.setup()

    MyObject.setup()

    MyObject().perform(#selector(MyObject.foo))
  }
}

class MyObject: NSObject {

  @objc func foo() {
    print("foo")
  }

  @objc func myFoo() {
    print("myfoo")
    self.perform(#selector(myFoo))
  }

  static func setup() {
    Hook.swizzlingForClass(
      MyObject.self,
      originalSEL: #selector(foo),
      swizzledSEL: #selector(myFoo)
    )
  }
}


extension UIPresentationController {
  static func setup() {
    //    self.swizzlingForClass(
    //      UIPresentationController.self,
    //      originalSEL: NSSelectorFromString("dealloc"),
    //      swizzledSEL: #selector(myDealloc)
    //    )

    Hook.swizzlingForClass(
      UIPresentationController.self,
      originalSEL: NSSelectorFromString("initWithPresentedViewController:presentingViewController:"),
      swizzledSEL: #selector(UIPresentationController.myInit(arg1:arg2:))
    )
  }

  @objc func myDealloc() {
    self.myDealloc()

    print(#function)
  }

  @objc func myInit(arg1: UIViewController, arg2: UIViewController) {
//    self.myInit(arg1: arg1, arg2: arg2)
    self.perform(
      #selector(UIPresentationController.myInit(arg1:arg2:)),
      with: arg1,
      with: arg2
    )
    print("my init")
  }


}

struct Hook {
  /** 替换方法 */
  static func swizzlingForClass(
    _ forClass: AnyClass,
    originalSEL: Selector,
    swizzledSEL: Selector
  ) {
    let originalMethod = class_getInstanceMethod(forClass, originalSEL)
    let swizzledMethod = class_getInstanceMethod(forClass, swizzledSEL)
    guard originalMethod != nil && swizzledMethod != nil else {
      return
    }

    if class_addMethod(
      forClass,
      originalSEL,
      method_getImplementation(swizzledMethod!),
      method_getTypeEncoding(swizzledMethod!)
    ) {
      class_replaceMethod(
        forClass,
        swizzledSEL,
        method_getImplementation(originalMethod!),
        method_getTypeEncoding(originalMethod!)
      )
    } else {
      method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
  }

}
