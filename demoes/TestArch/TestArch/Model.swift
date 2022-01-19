//
//  Model.swift
//  TestArch
//
//  Created by 席萍萍Brook.dinglan on 2021/12/29.
//

import Foundation

class Model {
    static let valueDidChange: Notification.Name = .init(rawValue: "Model.valueDidChange")
    static let textKey: String = "textKey"
    
    var value: String = "" {
        didSet {
            NotificationCenter.default.post(name: Model.valueDidChange,
                                            object: self,
                                            userInfo: [Model.textKey: value])
        }
    }
}
