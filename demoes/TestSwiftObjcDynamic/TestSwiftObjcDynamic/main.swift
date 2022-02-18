//
//  main.swift
//  TestSwiftObjcDynamic
//
//  Created by BrookXy on 2022/2/16.
//

import Foundation


class Person: NSObject {
    func swiftFunc() {
        print("swiftFunc")
    }
    
    @objc func objcFunc() {
        print("objcFunc")
    }
    
    @objc dynamic func dynamicFunc() {
        print("dynamicFunc")
    }
}

let ins = Person()
ins.swiftFunc()
ins.objcFunc()
ins.dynamicFunc()
