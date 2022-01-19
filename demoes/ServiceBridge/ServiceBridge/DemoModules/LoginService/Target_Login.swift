//
//  Target_Login.swift
//  ServiceBridge
//
//  Created by 席萍萍Brook.dinglan on 2021/9/30.
//

import Foundation


@objc(Target_Login)
class Login: NSObject {
    @objc func action_isLogin(_ params: [AnyHashable: Any]) -> [String: Any] {
        let userId = params["userId"]
        return ["boxed": LoginService.isLogin()]
    }
}
