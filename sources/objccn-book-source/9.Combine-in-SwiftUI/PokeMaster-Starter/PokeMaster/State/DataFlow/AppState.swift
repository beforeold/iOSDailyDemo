//
//  AppState.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/09/04.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Combine

struct AppState {
    var settings = Settings()
}

extension AppState {
    struct Settings {
        enum Sorting: CaseIterable {
            case id, name, color, favorite
        }

        enum AccountBehavior: CaseIterable {
            case register, login
        }

        var accountBehavior = AccountBehavior.login
        var email = ""
        var password = ""
        var verifyPassword = ""
        
        var showEnglishName = true
        var sorting = Sorting.id
        var showFavoriteOnly = false

        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?

        var loginRequesting = false
        var loginError: AppError?
    }
}
