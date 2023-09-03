//
//  AppCommand.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/10.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation
import Combine

protocol AppCommand {
    func execute(in store: Store)
}

struct LoginAppCommand: AppCommand {
    let email: String
    let password: String

    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoginRequest(
            email: email,
            password: password
        ).publisher
        .sink(
            receiveCompletion: { complete in
                if case .failure(let error) = complete {
                    store.dispatch(
                        .accountBehaviorDone(result: .failure(error))
                    )
                }
                token.unseal()
            },
            receiveValue: { user in
                store.dispatch(
                    .accountBehaviorDone(result: .success(user))
                )
            }
        )
        .seal(in: token)
    }
}


class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
