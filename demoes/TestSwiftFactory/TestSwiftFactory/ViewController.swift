//
//  ViewController.swift
//  TestSwiftFactory
//
//  Created by dinglan on 2021/6/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let hpMouse = HPFac.createMouse()
        hpMouse.logo()
        let dellKeyBo = DellFac.createKeyBo()
        dellKeyBo.logo()

        let dellMouse = DellFac.init().createMouse()
        dellMouse.logo()
        let HPkeybo = HPFac.init().createKeyBo()
        HPkeybo.logo()
    }
}

protocol Mouse {
    func logo()
}

protocol Keybo {
    func logo()
}

class PCFac {
    class func createMouse() -> Mouse { fatalError("nothing") }
    class func createKeyBo() -> Keybo { fatalError("nothing") }
}

class DellFac: PCFac {
    
    override class func createMouse() -> Mouse {
        return DellMouse.shared
    }

    override class func createKeyBo() -> Keybo {
        return DellKeybo.shared
    }
}

class HPFac: PCFac {
    
    override class func createMouse() -> Mouse {
        return HPMouse.shared
    }
    
    override class func createKeyBo() -> Keybo {
        return HPKeybo.shared
    }
}

class DellKeybo: Keybo {
    
    static let shared = DellKeybo()

    func logo() {
        print("dell keybo logo")
    }
}

class DellMouse: Mouse {

    static let shared = DellMouse()
    
    func logo() {
        print("dell mouse logo")
    }
}

class HPKeybo: Keybo {

    static let shared = HPKeybo()
    
    func logo() {
        print("hp keybo logo")
    }
}

class HPMouse: Mouse {

    static let shared = HPMouse()
    
    func logo() {
        print("HP mouse logo")
    }
}
