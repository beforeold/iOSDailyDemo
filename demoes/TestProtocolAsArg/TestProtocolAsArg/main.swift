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

struct Brook: Talkable {
    func talk() {
        print("brook talk")
    }
}

func unkownTypeTalk(by talker: Talkable) {
    print("talker", talker)
    talker.talk()
}

func genericTalk<T>(by talker: T) where T: Talkable {
    print("talker", talker)
    talker.talk()
}

unkownTypeTalk(by: Brook())
print()
genericTalk(by: Brook())


