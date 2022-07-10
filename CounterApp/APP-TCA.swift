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

struct ApiError: Error, Equatable {}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var increment: (Int, Int) -> Effect<Int, ApiError>
    var decrement: (Int, Int) -> Effect<Int, ApiError>
}

let APP_REDUCER = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case let .counter(counterAction):
        switch counterAction {
        case .decrementButtonTapped:
            state.counter.count -= 1
            return .none

        case .incrementButtonTapped:
            state.counter.count += 1
            return .none

        case let .decrementButtonTappedFetch(min):
            return environment.decrement(state.counter.count, min)
                .receive(on: environment.mainQueue)
                .catchToEffect {
                    AppAction.counter(CounterAction.numberChangeResponse($0))
                }
        case let .incrementButtonTappedFetch(max):
            return environment.increment(state.counter.count, max)
                .receive(on: environment.mainQueue)
                .catchToEffect {
                    AppAction.counter(CounterAction.numberChangeResponse($0))
                }
        case let .numberChangeResponse(.success(count)):
            state.counter.count = count
            state.counter.errorMessage = nil
            return .none

        case .numberChangeResponse(.failure):
            state.counter.errorMessage = "Sorry, you are out of range."
            return .none
        }
    }
}

let APP_STORE = Store(
    initialState: AppState(counter: CounterState()),
    reducer: APP_REDUCER,
    environment: AppEnvironment(
        mainQueue: .main,
        increment: { count, max in
            count + 1 < max ? Effect(value: count + 1) : Effect(error: ApiError())
        },
        decrement: { count, min in
            count - 1 > min ? Effect(value: count - 1) : Effect(error: ApiError())
        }
    )
)
