//
//  main.swift
//  TestProcoolNewFunction
//
//  Created by 席萍萍Brook.dinglan on 2021/11/26.
//

import Foundation

print("Hello, World!")

protocol AA {
    func aa()
}

extension AA {
    func aa() {
        print("\(self) aa")
    }
}

protocol BB {
    func bb()
}

extension BB {
    func bb() {
        print("\(self) bb")
    }
}

protocol CC {
    func cc()
}

extension CC {
    func cc() {
        print("\(self) cc")
    }
}

struct Live: AA {
    func aa() {
        print("aa")
    }
}

struct Login: AA, BB, CC {
    
}

struct AACC: AA, CC {
    
}

struct ComponentKit: AA, BB {
    func aa() {
        print("ComponentKit aa")
    }
    
    func bb() {
        print("ComponentKit bb")
    }
}

func api(_ ins: AA) {
    _api(ins, ins as? BB, ins as? CC)
}

func api(_ ins: AA & BB) {
    _api(ins, ins, ins as? CC)
}

func api(_ ins: AA & BB & CC) {
    _api(ins, ins, ins)
}

func _api(_ aa: AA, _ bb: BB?, _ cc: CC?) {
    aa.aa()
    bb?.bb()
}

api(ComponentKit())
api(AACC())
