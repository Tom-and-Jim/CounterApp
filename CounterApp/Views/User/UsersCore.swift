//
//  UsersCore.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/20.
//

import Foundation
import ComposableArchitecture

struct UsersState: Equatable {
    var users: IdentifiedArrayOf<UserDetailState>
    var userDetailSelection: UUID?
}

enum UsersAction: Equatable {
    case usersView(UserDetailState.ID, UserDetailAction)

    case setUserDetailSelection(UUID?)
}

struct UsersEnvironment {
    var user: UserClient.Interface
}

let usersReducer: Reducer<UsersState, UsersAction, UsersEnvironment> = .combine(
    userDetailReducer.forEach(
        state: \.users,
        action: /UsersAction.usersView,
        environment: { usersEnv in .init(user: usersEnv.user)}
    ),
    Reducer<UsersState, UsersAction, UsersEnvironment> { state, action, environment in
        struct TimerId: Hashable {}

        switch action {
        case let .setUserDetailSelection(id):
            state.userDetailSelection = id
            return .none
        default:
            return .none
        }
    }
)
