//
//  Notification+Extension.swift
//  TestArch
//
//  Created by 席萍萍Brook.dinglan on 2021/12/29.
//

import Foundation


extension Notification {
    var textKeyValue: String {
        return (userInfo?[Model.textKey] as? String) ?? ""
    }
}

extension NotificationCenter {
    func addObserver(using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return addObserver(forName: Model.valueDidChange, object: nil, queue: nil, using: block)
    }
}
