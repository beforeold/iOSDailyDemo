//
//  NestedSwiftNSObjectSubclass.swift
//  TestNestedSwiftNSObjectSubclass
//
//  Created by 席萍萍Brook.dinglan on 2021/11/8.
//

import UIKit

struct Nest {
    class NestedSwiftNSObjectSubclass: NSObject {

    }
}

class DirectSwiftNSObjectSubclass: NSObject {
    
}

func foo() {
    _ = Nest.NestedSwiftNSObjectSubclass()
}
