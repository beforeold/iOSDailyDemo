//
//  AppAction.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/09/05.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation

enum AppAction {
    case login(email: String, password: String)
    case accountBehaviorDone(result: Result<User, AppError>)
    case logout
    case emailValid(valid: Bool)
    case clearCache

    case closeSafariView

    // Pokemon List
    case toggleListSelection(index: Int?)
    case togglePanelPresenting(presenting: Bool)

    case loadPokemons
    case loadPokemonsDone(result: Result<[PokemonViewModel], AppError>)

    case loadAbilities(pokemon: Pokemon)
    case loadAbilitiesDone(result: Result<[AbilityViewModel], AppError>)
}
