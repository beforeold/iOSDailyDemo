//
//  Bridge+DemoExtension.swift
//  ServiceBridge
//
//  Created by 席萍萍Brook.dinglan on 2021/9/30.
//

import Foundation
import CoreGraphics


extension Bridge {
    func brook_isLogin() -> Bool {
        do {
            let ret = try Bridge.shared.perform(outputType: Bool.self,
                                                targetName: "Target_Login",
                                                actionName: "action_isLogin:",
                                                params: ["brook2":"hh",
                                                         "brook3" : CGRect.null,])
            return ret.1
        } catch {
            print(error)
            return false
        }
    }
}

extension Bridge {
    
    class UserInfo {
        
    }

    func brook_fun(model: UserInfo) {
        do {
            let ret = try Bridge.shared.perform(outputType: NSNull.self,
                                                targetName: "Target_Brook",
                                                actionName: "action_fun:",
                                                params: ["brook1": Bridge(),
                                                         "brook2":"hh",
                                                         "brook3" : CGRect.null,
                                                         "callback" : {},
                                                ])
            print(ret)
        } catch {
            print(error)
        }
    }
    
    func nancy_fun() -> CGRect {
        do {
            let ret = try Bridge.shared.perform(outputType: CGRect.self,
                                                targetName: "Target_Nancy",
                                                actionName: "action_fun2:",
                                                params: ["nancy1":"hh",
                                                         "nancy2" : CGRect.null])
            print(ret)
            return ret.1
            
        } catch {
            print(error)
            return CGRect.null
        }
    }
}
