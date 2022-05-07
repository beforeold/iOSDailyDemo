//
//  main.swift
//  TestMultipleCallbackWrapper
//
//  Created by BrookXy on 2022/5/7.
//

import Foundation

class Object {
    var onValueChanged = Callbacks<Int>()
    var onDone = Callbacks<Void>()
    
    func jobFinished() {
        onDone()
    }
    
    func change(_ value: Int) {
        onValueChanged(value)
    }
}

let object = Object()


object.onValueChanged { value in
    print("#1 onValueChanged", value, separator: " ")
}

object.onValueChanged { value in
    print("#2 onValueChanged", value, separator: " ")
}

object.onDone {[weak object] in
    _ = object
    print("onDone callback")
}

object.change(233)
object.change(666)

object.jobFinished()
