//
//  main.swift
//  TestNSClassFromStringSwift
//
//  Created by 席萍萍Brook.dinglan on 2021/10/16.
//

import Foundation


let fbClz = NSClassFromString("OCClass") as? NSObject.Type
print(fbClz as Any)

print("Hello, World!")

