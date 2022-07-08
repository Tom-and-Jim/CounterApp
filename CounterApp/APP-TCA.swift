//
//  APP-TCA.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/8.
//

import ComposableArchitecture

struct AppState: Equatable {
    var count = 0
    var errorMessage: String?
}

enum AppAction: Equatable {
    case decrementButtonTapped
    case incrementButtonTapped
    case decrementButtonTappedFetch(Int)
    case incrementButtonTappedFetch(Int)
    case numberChangeResponse(Result<Int, ApiError>)
}

struct ApiError: Error, Equatable {}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var increment: (Int, Int) -> Effect<Int, ApiError>
    var decrement: (Int, Int) -> Effect<Int, ApiError>
}

let APP_REDUCER = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
  switch action {
  case .decrementButtonTapped:
    state.count -= 1
    return .none

  case .incrementButtonTapped:
    state.count += 1
    return .none

  case let .decrementButtonTappedFetch(min):
    return environment.decrement(state.count, min)
      .receive(on: environment.mainQueue)
      .catchToEffect(AppAction.numberChangeResponse)
      
  case let .incrementButtonTappedFetch(max):
    return environment.increment(state.count, max)
      .receive(on: environment.mainQueue)
      .catchToEffect(AppAction.numberChangeResponse)

  case let .numberChangeResponse(.success(count)):
      state.count = count
      state.errorMessage = nil
    return .none

  case .numberChangeResponse(.failure):
      state.errorMessage = "Sorry, you are out of range."
    return .none
  }
}

let APP_STORE = Store(
    initialState: AppState(),
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
