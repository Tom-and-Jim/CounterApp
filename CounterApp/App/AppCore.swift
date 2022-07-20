//
//  AppCore.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/8.
//

import ComposableArchitecture

struct AppState: Equatable {
    var counter: CounterState
    var lock: LockState
    var counterActive: Bool
}

enum AppAction: Equatable {
    case counter(CounterAction)
    case lock(LockAction)
    case setCounterActive(Bool)
}

struct AppEnvironment {
    var counter: CounterEnvironment
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
    counterReducer.pullback(
        state: \.counter,
        action: /AppAction.counter,
        environment: { $0.counter }
    ),
    lockReducer.pullback(
        state: \.lock,
        action: /AppAction.lock,
        environment: { .init(counter: $0.counter) }
    ),
    Reducer { state, action, _ in
        switch action {
        case .setCounterActive(let active):
            print("setCounterActive")
            state.counterActive = active
            return .none
        default:
            return .none
        }
    }
)

let appStore = Store<AppState, AppAction>(
    initialState: AppState(
        counter: CounterState(id: UUID()),
        lock: .init(
            digitals: [
                CounterState(id: UUID()),
                CounterState(id: UUID()),
                CounterState(id: UUID())
            ],
            codes: [9, 5, 7],
            unlock: false
        ),
        counterActive: false
    ),
    reducer: appReducer,
    environment: AppEnvironment(
        counter: counterEnvironment
    )
)

struct ApiError: Error, Equatable {}
