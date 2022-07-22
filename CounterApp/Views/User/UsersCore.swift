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

    case startTimerSchedule
    case stopTimerSchedule
    case timerTicked
}

struct UsersEnvironment {
    var user: UserClient.Interface
    var mainQueue: AnySchedulerOf<DispatchQueue>
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
        case let .setUserDetailActive(active):
            state.userDetailActive = active
            return .none
        case .startTimerSchedule:
            return Effect.timer(id: TimerId(), every: 5, tolerance: nil, on: environment.mainQueue, options: nil)
                .map { _ in .timerTicked }
        case .stopTimerSchedule:
            return .cancel(id: TimerId.self)
        case .timerTicked:
            if state.users.count > 0 {
                var firstItem = state.users.first!
                firstItem.user.user.lastName = Randoms.randomFakeLastName()
                state.users.update(firstItem, at: 0)
            }
            return .none
        default:
            return .none
        }
    }
)
