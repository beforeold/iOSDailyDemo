//
//  main.swift
//  TestNSNullBridging
//
//  Created by BrookXy on 2022/3/25.
//

import Foundation

print("Hello, World!")

class SwiftCar : NSObject {
    @objc func play(args: [Any]?) {
        print(args as Any)
    }
}

class SwiftBike: OCObject {
    override func subclass_play(withArgs args: [Any]) {
        print(args)
    }
}

OCTestEntry.test()
