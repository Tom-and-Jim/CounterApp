//
//  CounterTCA.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/11.
//

import ComposableArchitecture

// MARK: - All
struct CounterState: Equatable {
    var count = 0
    var errorMessage: String?
}

enum CounterAction: Equatable {
    case decrementButtonTapped
    case incrementButtonTapped
    case decrementButtonTappedFetch(Int)
    case incrementButtonTappedFetch(Int)
    case numberChangeResponse(Result<Int, ApiError>)
}

struct CounterEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var increment: (Int, Int) -> Effect<Int, ApiError>
    var decrement: (Int, Int) -> Effect<Int, ApiError>
}

let counterEnvironment = CounterEnvironment(
    mainQueue: .main,
    increment: { count, max in
        count + 1 < max ? Effect(value: count + 1) : Effect(error: ApiError())
    },
    decrement: { count, min in
        count - 1 > min ? Effect(value: count - 1) : Effect(error: ApiError())
    }
)

let counterReducer = Reducer<CounterState, CounterAction, CounterEnvironment> {
    state, action, environment in
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
                .catchToEffect {
                    .numberChangeResponse($0)
                }
        case let .incrementButtonTappedFetch(max):
            return environment.increment(state.count, max)
                .receive(on: environment.mainQueue)
                .catchToEffect {
                    .numberChangeResponse($0)
                }
        case let .numberChangeResponse(.success(count)):
            state.count = count
            state.errorMessage = nil
            return .none

        case .numberChangeResponse(.failure):
            state.errorMessage = "Sorry, you are out of range."
            return .none
    }
}


// MARK: - CounterView

extension CounterView {
    struct State: Equatable {
        var count = 0
    }
}

extension CounterState {
  var view: CounterView.State {
    .init(count: self.count)
  }
}

// MARK: - EditCounterView

extension EditCounterView {
    struct State: Equatable {
        var count = 0
        var errorMessage: String?
    }
    
    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
        case decrementButtonTappedFetch(Int)
        case incrementButtonTappedFetch(Int)
    }
}

extension CounterState {
  var editView: EditCounterView.State {
    .init(count: self.count, errorMessage: self.errorMessage)
  }
}

extension EditCounterView.Action {
    var feature: CounterAction {
        switch self {
        case .decrementButtonTapped:
            return .decrementButtonTapped
        case .incrementButtonTapped:
            return .incrementButtonTapped
        case let .decrementButtonTappedFetch(counter):
            return .decrementButtonTappedFetch(counter)
        case let .incrementButtonTappedFetch(counter):
            return .incrementButtonTappedFetch(counter)
        }
    }
}
