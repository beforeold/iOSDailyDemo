//
//  AppError.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/08/28.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation

enum AppError: Error, Identifiable {
    var id: String { localizedDescription }

    case alreadyRegistered
    case passwordWrong

    case requiresLogin
    case networkingFailed(Error)
    case fileError
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .alreadyRegistered: return "该账号已注册"
        case .passwordWrong: return "密码错误"
        case .requiresLogin: return "需要账户"
        case .networkingFailed(let error): return error.localizedDescription
        case .fileError: return "文件操作错误"
        }
    }
}
