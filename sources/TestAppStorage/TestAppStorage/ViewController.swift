//
//  ViewController.swift
//  TestAppStorage
//
//  Created by Brook_Mobius on 2023/4/6.
//

import SwiftUI

class ViewController: UIHostingController<HomeView> {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder, rootView: HomeView(flag: sharedBinding))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    sharedBinding.wrappedValue = true
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
