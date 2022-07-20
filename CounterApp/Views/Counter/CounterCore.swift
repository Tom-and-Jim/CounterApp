//
//  CounterTCA.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/11.
//

import ComposableArchitecture

// MARK: - All
struct CounterState: Equatable, Identifiable {
    let id: UUID
    var count = 0
    var errorMessage: String?
}

enum CounterAction: Equatable {
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
        count + 1 > max ? Effect(error: ApiError()) : Effect(value: count + 1)
    },
    decrement: { count, min in
        count - 1 < min ? Effect(error: ApiError()) : Effect(value: count - 1)
    }
)

let counterReducer = Reducer<CounterState, CounterAction, CounterEnvironment> { state, action, environment in
    switch action {
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
        case let .decrementButtonTappedFetch(counter):
            return .decrementButtonTappedFetch(counter)
        case let .incrementButtonTappedFetch(counter):
            return .incrementButtonTappedFetch(counter)
        }
    }
}
