//
//  Target_Nancy.swift
//  ServiceBridge
//
//  Created by 席萍萍Brook.dinglan on 2021/9/30.
//

import Foundation
import CoreGraphics


@objc(Target_Nancy)
class Nancy: NSObject {
    @objc func action_fun2(_ params: [String: Any]) -> CGRect {
        print("cool")
        
        return .zero
//        return ["boxed": CGRect()]
    }
}
