//
//  main.swift
//  TestProtocolAsArg
//
//  Created by BrookXy on 2022/2/10.
//

import Foundation

protocol Talkable {
    func talk()
}

extension Talkable {
    func talkTwice() {
        talk()
        talk()
    }
}

struct Brook1: Talkable {
    func talk() {
        print("brook1 talk")
    }
}

struct Brook2: Talkable {
    func talk() {
        print("brook2 talk")
    }
    
    func talkTwice() {
        print("brook talk twice")
    }
}

func unkownTypeTalk(by talker: Talkable) {
    print("talker unkown", talker)
    talker.talk()
    talker.talkTwice()
}

func genericTalk<T>(by talker: T) where T: Talkable {
    print("talker generic", talker)
    talker.talk()
    talker.talkTwice()
}


// just the same

unkownTypeTalk(by: Brook1())
print()
genericTalk(by: Brook2())



protocol Parentable {
    associatedtype Child
    func whichChild() -> Child.Type
}

// fail to build
// func testParent1(parent: Parentable)

// ok to build
func testParent2<T>(parent: T) where T: Parentable {
    
}
