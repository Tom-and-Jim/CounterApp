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
    var userDetailActive: Bool
}

enum UsersAction: Equatable {
    case usersView(UserDetailState.ID, UserDetailAction)

    case setUserDetailActive(Bool)

    case startUpdateUserDetailTimer(UserDetailState.ID)
    case stopUpdateUserDetailTimer
    case timerTicked(UserDetailState.ID)
}

struct UsersEnvironment {
    var user: UserDetailEnvironment
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let usersReducer: Reducer<UsersState, UsersAction, UsersEnvironment> = .combine(
    userDetailReducer.forEach(
        state: \.users,
        action: /UsersAction.usersView,
        environment: \.user
    ),
    Reducer<UsersState, UsersAction, UsersEnvironment> { state, action, environment in
        struct TimerId: Hashable {}

        switch action {
        case let .setUserDetailActive(active):
            state.userDetailActive = active
            return .none
        case .startUpdateUserDetailTimer(let id):
            return Effect.timer(id: TimerId(), every: 5, tolerance: nil, on: environment.mainQueue, options: nil)
                .map { _ in .timerTicked(id) }
        case .stopUpdateUserDetailTimer:
            return .none
        case .timerTicked(let id):
            if var target = state.users.first(where: { userState in userState.id == id }) {
                target.user.age = 100
            }
            return .none
        default:
            return .none
        }
    }
)
