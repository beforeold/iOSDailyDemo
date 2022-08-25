//
//  main.swift
//  TestSwiftClosureTypealias
//
//  Created by 席萍萍Brook.dinglan on 2021/12/14.
//

import Foundation

print("Hello, World!")

public typealias LinkLaunchReporter = (_ url: URL?, _ userInfo: [AnyHashable: Any]?) -> [AnyHashable: Any]?

@objc(LAPerson)
@objcMembers
class Person: NSObject {
    var rep1: LinkLaunchReporter?
    var rep2: (LinkLaunchReporter)?
    
    var age: (Int) = 5
}

let pp = Person()
pp.rep1 = { url, userInfo in
    return nil
}


pp.rep2 = { url, userInfo in
    return nil
}

_ = pp.rep1?(nil, nil)
let rep2 = pp.rep2
// let rep2_0 = rep2!.0

let age = pp.age
print(age)
