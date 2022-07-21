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
    var min: Int = 0
    var max: Int = 9
    var errorMessage: String?
    var editCounterActive: Bool = false
}

enum CounterAction: Equatable {
    case decrement
    case increment
    case incrementComplete(Result<Int, CounterClient.IncrementError>)
    case decrementComplete(Result<Int, CounterClient.DecrementError>)
    case setEditCounter(Bool)
}

let counterReducer = Reducer<CounterState, CounterAction, CounterClient.Interface> { state, action, environment in
    switch action {
        case .decrement:
            return environment.decrement(state.count, state.min)
                .catchToEffect(CounterAction.decrementComplete)
        case .increment:
            return environment.increment(state.count, state.max)
                .catchToEffect(CounterAction.incrementComplete)
        case let .decrementComplete(.success(value)),
             let .incrementComplete(.success(value)):
            state.count = value
            state.errorMessage = nil
            return .none
        case .decrementComplete(.failure(.minBoundReached)):
            state.errorMessage = "Sorry, you are min than \(state.min)."
            return .none
        case .incrementComplete(.failure(.maxBoundReached)):
            state.errorMessage = "Sorry, you are max than \(state.max)."
            return .none
        case let .setEditCounter(active):
            state.editCounterActive = active
            return .none
    }
}
