//
//  SomeNSObjectProtocol.swift
//  TestSwiftNSObjectProtocol
//
//  Created by BrookXy on 2022/1/7.
//

import Foundation

@objc protocol SomeNSObjectProtocol: NSObjectProtocol {
    
}

class Wrapper: NSObject {
    var base: SomeNSObjectProtocol?
}

class MyClass: NSObject {
    @objc func get() -> SomeNSObjectProtocol? {
        return nil
    }
    
    @objc func get2() -> Wrapper? {
        return nil
    }
}
