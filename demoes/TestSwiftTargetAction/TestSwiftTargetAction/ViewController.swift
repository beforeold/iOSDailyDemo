//
//  ViewController.swift
//  TestSwiftTargetAction
//
//  Created by 席萍萍Brook.dinglan on 2021/11/9.
//

import UIKit

protocol TargetAction {
    func performAction()
}

struct TargetActionWrapper<T: AnyObject>: TargetAction {
    weak var target: T?
    let action: (T) -> () -> ()
    
    func performAction() -> () {
        if let t = target {
            action(t)()
        }
    }
}

enum ControlEvent {
    case TouchUpInside
    case ValueChanged
    // ...
}



protocol Bagable: AnyObject {
    var bag: [Any] { get }
}

extension Bagable {
    var bag: [Any] {
        get {
            // use objc association
            return []
        }
        
        set {
            
        }
    }
}

extension NSObject: Bagable { }

class Control {
    var actions = [ControlEvent: TargetAction]()
    
    func setTarget<T: AnyObject>(target: T,
                                 action: @escaping (T) -> () -> (),
                                 controlEvent: ControlEvent) {
        
        actions[controlEvent] = TargetActionWrapper(
            target: target, action: action)
    }
    
    func removeTargetForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent] = nil
    }
    
    func performActionForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent]?.performAction()
    }
}


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let tap = UITapGestureRecognizer()
        tap.lion_addTarget(self, method: ViewController.action)
    }
    
    func action() {
        
    }
}

extension UIGestureRecognizer {
    class Token<Target: AnyObject> {
        weak var target: Target?
        let action: (Target) -> () -> ()
        
        init(target: Target, action: @escaping (Target) -> () -> ()) {
            self.target = target
            self.action = action
        }
        
        @objc func callback(gesutre: UIGestureRecognizer) {
            if let target = target {
                action(target)()
            }
        }
    }
    
    @discardableResult
    func lion_addTarget<Target: AnyObject>(_ target: Target,
                                           method: @escaping (Target) -> () -> ()) -> Token<Target> {
        let token = Token(target: target, action: method)
        addTarget(token, action: #selector(Token<Target>.callback))
        bag.append(token)
        
        return token
    }
    
    func lion_removeToken<Target>(_ token: Token<Target>) {
        self.bag.removeAll { ins in
            let obj = ins as AnyObject
            return obj === token
        }
    }
}
