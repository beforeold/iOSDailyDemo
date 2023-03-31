//
//  SecondViewController.swift
//  TestMethodAsClosure
//
//  Created by Brook_Mobius on 2023/3/31.
//

import UIKit

class SecondViewController: UIViewController {
  
  var callback: (() -> Void)?
  
  var delegate = Delegate<Void, Void>()
  
  var callbackWithArg: ((Int) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .gray
    
    // leaks
    // self.callback = showTextLog
    // // 相当于 self.callback = { self.showTextLog() }
    
    // leaks
    // 使用方法名的本质
    // let foo = SecondViewController.showTextLog
    // self.callback = foo(self)
    
    // leaks
    // 原因还是传入了 self 用于调用 showTextLog
    // weak var weakSelf = self
    // let weakFunc = weakSelf?.showTextLog
    // self.callback = weakFunc
    
    // leaks
    // let box = WeakBox(self)
    // self.callback = box.value?.showTextLog
    
    // no leaks
    // self.callback = { [weak self] in
    //  self?.showTextLog()
    // }
    
    self.callback = WeakWrapper(self).call {
      $0.showTextLog
    }
    
    self.callback = weakify(self) { (self) in
      self.showTextLog()
    }
    
    self.delegate.delegate(on: self) { (self, _) in
      self.showTextLog()
    }

    let foo = weakify(self) { (self, arg) in
      self.showTextLog(value: arg)
    }
    self.callbackWithArg = foo
    
    self.callbackWithArg = weakify(self, { strongSelf, arg in
      strongSelf.showTextLog(value: arg)
    })
    
    demoRequest()
  }
  
  func demoRequest() {
    DemoNetwork.request(
      callback: weakify(self) { (self, value) in
      self.showTextLog(value: value)
    })

    DemoNetwork.request(
      callback: WeakWrapper(self).build { `self`, arg in
        self.showTextLog(value: arg)
    })
    
    DemoNetwork.request { [weak self] value in
      self?.showTextLog(value: value)
    }
  }
  
  deinit {
    print("deinit")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    callback?()
    
    delegate.call(())
    
    callbackWithArg?(5)
    
    dismiss(animated: true)
  }
  
  
  func showTextLog() {
    print(#function)
  }
  
  func showTextLog(value: Int) {
    print(#function)
  }
}

struct DemoNetwork {
  static func request(callback: @escaping (Int) -> Void) {
  }
}
