//
//  ViewController.swift
//  TestArticle
//
//  Created by BrookXy on 2022/4/27.
//

import UIKit
import Combine

public class Cook: NSObject {
    private var money: Double = 0
    @objc public func earn(moreMoney: Double) {
        money += moreMoney
    }
}

class ViewController: UIViewController {

    func login() async throws {
        
    }
    
    func follow(userId: Int) async throws -> Bool {
        return false
    }
    
    
    func foo() async throws -> Bool {
        try await login() // a
        let ret = try await follow(userId: 2333) // b
        return ret
    }
    
    func login(completion: @escaping () -> Void) {
        
    }
    
    func follow(userId: Int, completion: @escaping (Bool) -> Void) {
        
    }
    
    func foo2() {
        login {
            self.follow(userId: 2333) { ret in
                print(ret)
            }
        }
    }
    
    var label: UILabel!
    
    var set = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        label = UILabel()
        view.addSubview(label)
        
        
    NotificationCenter.default
        .publisher(for: Notification.Name(rawValue: "SomeNotification"))
        .map { $0.userInfo?["someKey"] as? String }
        .assign(to: \.label.text, on: self)
        .store(in: &set)
    }


}
