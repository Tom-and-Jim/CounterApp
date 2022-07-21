//
//  AppCore.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/8.
//

import ComposableArchitecture

// MARK: - State

struct AppState: Equatable {
    var root: RootState = .init()
}

// MARK: - Action

enum AppAction: Equatable {
    case rootView(RootAction)
}

// MARK: - Environment

struct AppEnvironment {
    var counterClient: CounterClient.Interface
}

// MARK: - children environment derivations

extension AppEnvironment {
    var root: RootEnvironment {
        .init(counter: self.counterClient)
    }
}

// MARK: - Reducer

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
    rootReducer.pullback(
        state: \.root,
        action: /AppAction.rootView,
        environment: \.root
    )
)

// MARK: - appStore

// We set appStore here as global in order to pass to PreviewProvider easily
let appStore = Store<AppState, AppAction>(
    initialState: AppState(),
    reducer: appReducer,
    environment: AppEnvironment()
)
