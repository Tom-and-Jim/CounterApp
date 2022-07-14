//
//  AppCore.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/8.
//

import ComposableArchitecture

struct AppState: Equatable {
    var counter: CounterState
    var lock: IdentifiedArrayOf<CounterState> = []
}

enum AppAction: Equatable {
    case counter(CounterAction)
    case lock(id: CounterState.ID, action: CounterAction)
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
    counterReducer.forEach(
        state: \.lock,
        action: /AppAction.lock(id:action:),
        environment: { _ in counterEnvironment }
    )
)

let appStore = Store<AppState, AppAction>(
    initialState: AppState(
        counter: CounterState(id: UUID()),
        lock: [
            CounterState(id: UUID()),
            CounterState(id: UUID()),
            CounterState(id: UUID())
        ]
    ),
    reducer: appReducer,
    environment: AppEnvironment(
        counter: counterEnvironment
    )
)

struct ApiError: Error, Equatable {}
