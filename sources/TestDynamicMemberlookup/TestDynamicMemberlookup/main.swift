//
//  main.swift
//  TestDynamicMemberlookup
//
//  Created by BrookXy on 2022/1/9.
//

import Foundation

@dynamicCallable @dynamicMemberLookup
class WeiSuoYuWei {
    
    func dynamicallyCall(withArguments args: [String]) -> Double {
        return 0
    }
    
    subscript(dynamicMember member: String) -> String {
        return ""
    }
}

let niuBi = WeiSuoYuWei()
niuBi("")
let sm = niuBi.someMethod
niuBi.someMethod.dynamicallyCall(withKeywordArguments: ["wei_suo_yu_wei": true])


