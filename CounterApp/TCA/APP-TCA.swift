//
//  APP-TCA.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/8.
//

import ComposableArchitecture

struct AppState: Equatable {
    var counter: CounterState
}

enum AppAction: Equatable {
    case counter(CounterAction)
}

struct AppEnvironment {
    var counter: CounterEnvironment
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
    counterReducer.pullback(
        state: \.counter,
        action: /AppAction.counter,
        environment: { $0.counter }
    )
)

let APP_STORE = Store<AppState, AppAction>(
    initialState: AppState(counter: CounterState()),
    reducer: appReducer,
    environment: AppEnvironment(
        counter: counterEnvironment
    )
)

struct ApiError: Error, Equatable {}
