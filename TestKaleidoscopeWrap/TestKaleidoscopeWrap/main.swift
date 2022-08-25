//
//  main.swift
//  TestKaleidoscopeWrap
//
//  Created by BrookXy on 2022/1/10.
//

import Foundation

protocol KSProtocol {
    
}

protocol GroupProtocol: KSProtocol {
    
}


protocol KSLayoutProtocol: KSProtocol {
    func addGroup(_ group: GroupProtocol)
}

struct GroupA: GroupProtocol {
    
}

struct GroupB: GroupProtocol {
    
}

extension KSProtocol {
    func casted<T>() -> T {
        return self as! T
    }
}

struct LayoutA: KSLayoutProtocol {
    func addGroup(_ group: GroupProtocol) {
        addGroup(group.casted())
    }
    
    func addGroup(_ group: GroupA) {
        print("add group a")
    }
}

struct LayoutB: KSLayoutProtocol {
    func addGroup(_ group: GroupProtocol) {
        addGroup(group.casted())
    }
    
    func addGroup(_ group: GroupB) {
        print("add group b")
    }
}

var usePlanA = true

struct KSLayout {
    static func createLayout() -> KSLayoutProtocol {
        return usePlanA ? LayoutA() : LayoutB()
    }
}

struct KSGroup {
    static func createGroup() -> GroupProtocol {
        return usePlanA ? GroupA() : GroupB()
    }
}

func foo() {
    let layout = KSLayout.createLayout()
    let group = GroupB()
    layout.addGroup(group)
}

foo()
