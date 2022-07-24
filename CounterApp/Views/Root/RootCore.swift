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

    case startTimerSchedule
    case stopTimerSchedule
    case timerTicked
}

struct RootEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>

    var counter: CounterClient.Interface
    var user: UserClient.Interface
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
    usersReducer.optional().pullback(
        state: \.users,
        action: /RootAction.users,
        environment: { .init(user: $0.user) }
    ),
    Reducer { state, action, environment in

        struct TimerId: Hashable {}

        switch action {
        case .setCounterActive(let active):
            state.counterActive = active
            return .none
        case .setLockActive(let active):
            state.lockActive = active
            return .none
        case .setUsersActive(let active):
            if active {
                state.users = .fake()
                state.usersActive = active
                return Effect(value: .startTimerSchedule)
            } else {
                state.users = nil
                state.usersActive = active
                return Effect(value: .stopTimerSchedule)
            }
        case .startTimerSchedule:
            return Effect.timer(id: TimerId(), every: 5, tolerance: nil, on: environment.mainQueue, options: nil)
                .map { _ in .timerTicked }
        case .stopTimerSchedule:
            return .cancel(id: TimerId.self)
        case .timerTicked:
            if (state.users?.users.count ?? 0) > 0 {
                guard var firstItem = state.users?.users.first else {
                    return .none
                }
                firstItem.user.lastName = Randoms.randomFakeLastName()
                state.users?.users.update(firstItem, at: 0)
            }
            return .none
        default:
            return .none
        }
    }
)
