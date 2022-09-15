//
//  TestObject.swift
//  TestOCProtocolSwift
//
//  Created by 席萍萍Brook.dinglan on 2021/10/26.
//

import Foundation

class TestObject: NSObject, TestProtocol {
//    internal var file: FileObject?
//    var file: FileObject? {
//        get {
//            print("get")
//            return nil
//        }
//
//        set {
//            print("set")
//        }
//    }
}
//
//class Setter<P: TestProtocol>: NSObject {
//    private var wrapped: P
//    public init(wrapped: P) {
//        self.wrapped = wrapped
//        super.init()
//    }
//    open var file : FileObject? {
//        get {
//            wrapped.file ?? nil
//        }
//        set {
//            // wrapped.keyboardAppearance =
//            let kp = \Setter.wrapped.file
//            self[keyPath: kp] = newValue
//        }
//    }
//}

@objc class Demo: NSObject {
    @objc
    static func foo() {
        let test = TestObject()
        _ = test as (NSObject & TestProtocol)
//        _ = obj.file??.description
    //    obj.file = FileObject()

      
        if test.responds(to: NSSelectorFromString("file")) &&
                            test.responds(to: NSSelectorFromString("setFile:")) {
            test[keyPath: \TestProtocol.file] = FileObject()
        } else {
            print("not responds")
        }
    }
}





@objc public protocol P {
    @objc optional var keyboardAppearance : NSString {get set}
}

open class C : NSObject {
    private var wrapped: P
    public init(wrapped: P) {
        self.wrapped = wrapped
        super.init()
    }
    open var keyboardAppearance : NSString {
        get {
            wrapped.keyboardAppearance ?? "" as NSString
        }
        set {
            // wrapped.keyboardAppearance =
            let kp = \C.wrapped.keyboardAppearance
            self[keyPath:kp] = newValue
        }
    }
}
