//
//  main.swift
//  TestSwiftSubclassInit
//
//  Created by 席萍萍Brook.dinglan on 2021/12/13.
//

import Foundation


open class NSCollectionLayoutSpacing : NSObject {
//        open class func flexible(_ flexibleSpacing: CGFloat) -> Self {
//            Self.init()
//        }
    
//
//    open class func fixed(_ fixedSpacing: CGFloat) -> Self {
//        return Self.init(spacing: fixedSpacing, isFlexible: false)
//    }
//
    
    convenience init(spacing: CGFloat, isFlexible: Bool) {
        self.init()
        self.spacing = spacing
        self.isFlexible = isFlexible
        self.isFixed = !isFlexible
    }

    open internal(set) var spacing: CGFloat = 0

    open internal(set) var isFlexible: Bool = false

    open internal(set) var isFixed: Bool = true
}

//
//extension Name1.NSCollectionLayoutSpacing {
//    func foo<T: Name1.NSCollectionLayoutSpacing>(spacing: CGFloat) -> T {
//        return T.init() as! T
//    }
//}
