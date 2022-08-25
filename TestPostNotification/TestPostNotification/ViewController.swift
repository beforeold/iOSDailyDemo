//
//  ViewController.swift
//  TestPostNotification
//
//  Created by BrookXy on 2022/1/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNoti(_:)), name: .init(rawValue: "lock_go"), object: nil)
    }
    
    @objc func onNoti(_ noti: Notification) {
//        NotificationCenter.default.addObserver(self, selector: #selector(onNext(_:)), name: .init(rawValue: "lock_next"), object: nil)
        NotificationCenter.default.addObserver(forName: .init(rawValue: "lock_next"), object: nil, queue: OperationQueue.main) { note in
            print(note)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: .init(rawValue: "lock_go"), object: self)
    }
    
    @objc func onNext(_ noti: Notification) {
        print("on next \(noti)")
    }
}

