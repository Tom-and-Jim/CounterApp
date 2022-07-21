//
//  AppCore.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/8.
//

import ComposableArchitecture

struct RootState: Equatable {
    var counter: CounterState = CounterState(id: UUID())
    var lock: LockState = .init(
        digitals: [
            CounterState(id: UUID()),
            CounterState(id: UUID()),
            CounterState(id: UUID())
        ],
        codes: [9, 5, 7],
        unlock: false
    )
    var users: UsersState?

    var counterActive: Bool = false
    var lockActive: Bool = false
    var usersActive: Bool = false
}

enum RootAction: Equatable {
    case counter(CounterAction)
    case lock(LockAction)
    case users(UsersAction)

    case setCounterActive(Bool)
    case setLockActive(Bool)
    case setUsersActive(Bool)
}

struct RootEnvironment {
    var counter: CounterClient.Interface
}

let rootReducer: Reducer<RootState, RootAction, RootEnvironment> = .combine(
    counterReducer.pullback(
        state: \.counter,
        action: /RootAction.counter,
        environment: { $0.counter }
    ),
    lockReducer.pullback(
        state: \.lock,
        action: /RootAction.lock,
        environment: { .init(counter: $0.counter) }
    ),
    Reducer { state, action, _ in
        switch action {
        case .setCounterActive(let active):
            state.counterActive = active
            return .none
        case .setLockActive(let active):
            state.lockActive = active
            return .none
        case .setUsersActive(let active):
            if active {
                state.users = UsersState(
                    users: [
                        UserDetailState(id: UUID(), user: UserState(firstName: "f1", lastName: "l1", email: "e1", age: 1, job: "j1"), editUserActive: false),
                        UserDetailState(id: UUID(), user: UserState(firstName: "f2", lastName: "l2", email: "e2", age: 2, job: "j2"), editUserActive: false)
                    ],
                    userDetailActive: false
                )
            } else {
                state.users = nil
            }
            state.usersActive = active
            return .none
        default:
            return .none
        }
    }
)
