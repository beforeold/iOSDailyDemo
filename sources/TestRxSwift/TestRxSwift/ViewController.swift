//
//  RxDemoViewController.swift
//  TestRxSwift
//
//  Created by beforeold on 2022/10/14.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Combine

/// convert string -> int
fileprivate func intValue(_ string: String?) -> Int {
  let int = string?.last
    .flatMap(String.init)
    .flatMap(Int.init)
  return int ?? -1
}


class ViewController: UIViewController {
  
  @IBOutlet weak var counterLabel: UILabel!
  @IBOutlet weak var inputField: UITextField!
  
  var counterDisposable: Disposable!
  var counterDisposableBag: DisposeBag! = DisposeBag()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // firstRx()
    // RxObservableType.test()
    rxCounter()
  }
  
  // https://boxueio.com/series/reactive-programming-in-swift/episode-documents/74
  func firstRx() {
    _ = inputField.rx.text
      .map(intValue)
      .filter { $0 % 2 == 0}
      .observe { value in
        print(value)
      }
  }
  
  
  func rxCounter() {
    let pub = Observable<Int>.interval(.seconds(1),
                                       scheduler: MainScheduler.instance)
    counterDisposable = pub.observe(onNext: { value in
      self.counterLabel.text = "\(value)"
    })
    
    pub
      .map(String.init)
      .bind(to: counterLabel.rx.text)
      .disposed(by: counterDisposableBag)
  }
  
  @IBAction func onStopCounter(_ sender: Any) {
    // 手动进行销毁
    // counterDisposable.dispose()
    
    // 在订阅时主动加入 bag，然后根据 bag 一起销毁
    counterDisposable.disposed(by: counterDisposableBag)
    counterDisposableBag = nil
  }
  
  @IBAction func onShowLogin(_ sender: Any) {
    demo(LoginViewController.self)
  }
  
  @IBAction func onShowProfile(_ sender: Any) {
    demo(ProfileViewController.self)
  }
  
  @IBAction func onShowGitHub(_ sender: Any) {
    demo(GitHubSearchViewController.self)
  }
  
  private func demo(_ vcType: UIViewController.Type) {
    let vc = vcType.init()
    present(vc, animated: true)
  }
}

fileprivate func foo() {
  let publisher = PassthroughSubject<Int, Never>()
  _ = publisher.sink { value in
    print(value)
  }
}
