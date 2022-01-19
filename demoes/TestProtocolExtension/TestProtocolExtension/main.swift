//
//  main.swift
//  TestProtocolExtension
//
//  Created by dinglan on 2021/4/26.
//

import Foundation


enum ComponentPositionType {
    case header
    case body
    case bottom
    case dialog
    case global
}

protocol ComponentPosition {
    func positionType() -> ComponentPositionType
}

extension ComponentPosition {
    func positionType() -> ComponentPositionType {
        print("body")
        return .body
    }
}


class MLCComponent  {
    
}


class PaymentBaseComponent: MLCComponent, ComponentPosition {
    func positionType() -> ComponentPositionType {
        return .global
    }
}

class PaymentBaseComponent1 : PaymentBaseComponent, ComponentPosition {
    func positionType() -> ComponentPositionType {
        return .header
    }
}

//extension ComponentPosition where Self == PaymentBaseComponent1 {
//    func positionType() -> ComponentPositionType {
//        return .header
//    }
//}
//
//extension PaymentBaseComponent1: ComponentPosition {
//    override
//}

class PaymentBaseComponent2 : PaymentBaseComponent {
    
}

class PaymentBaseComponent3 : PaymentBaseComponent {
    
}

let c1 = PaymentBaseComponent1() as ComponentPosition
print(c1.positionType())
