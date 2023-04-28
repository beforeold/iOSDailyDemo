//
//  ViewController.swift
//  TestAppStorage
//
//  Created by Brook_Mobius on 2023/4/6.
//

import SwiftUI

class ViewController: UIHostingController<HomeView> {
  
  @StateObject var viewModel: ViewModel = .shared
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder, rootView: HomeView(flag: .constant(true)))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    resetRootView()
  }
  
  func resetRootView() {
    let button = UIButton(type: .custom)
    button.frame = CGRectMake(100, 100, 200, 100)
    button.setTitle("onToggleFlag", for: .normal)
    button.addTarget(self, action: #selector(onToggleFlag), for: .touchUpInside)
    button.setTitleColor(.blue, for: .normal)
    view.addSubview(button)
    
    // self.rootView = HomeView(flag: $viewModel.flag)
    self.rootView = HomeView(flag: sharedBinding)
  }
  
  @objc func onToggleFlag() {
    print(#function)
    sharedBinding.wrappedValue = true
    
    viewModel.flag = true
  }
  
  func mockObserver() {
    Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(onTick), userInfo: nil, repeats: true)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(onUserDefaultsChange(_:)),
      name: UserDefaults.didChangeNotification,
      object: nil
    )
  }
  
  @objc func onUserDefaultsChange(_ note: Notification) {
    print(#function, Thread.current, note)
  }
  
  @objc func onTick() {
    DispatchQueue.global().async {
      let key = "settings.count"
      var value = UserDefaults.standard.integer(forKey: key)
      value += 100
      UserDefaults.standard.set(value, forKey: key)
    }
  }


}
