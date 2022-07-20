//
//  LockCore.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/19.
//

import Foundation
import ComposableArchitecture

struct LockState: Equatable {
    var digitals: IdentifiedArrayOf<CounterState>
    var codes: [Int]
    var unlock: Bool
}

enum LockAction: Equatable {
    case digitalView(CounterState.ID, CounterAction)
}

struct LockEnvironment {
    var counter: CounterEnvironment
}

let lockReducer: Reducer<LockState, LockAction, LockEnvironment> = .combine(
    counterReducer.forEach(
        state: \.digitals,
        action: /LockAction.digitalView,
        environment: \.counter
    ),
    Reducer { state, action, _ in
        switch action {
        case .digitalView(_, .numberChangeResponse(.success(_))):
            state.unlock = state.digitals.map(\.count) == state.codes
            return .none
        case .digitalView:
            return .none
        }
    }
)


