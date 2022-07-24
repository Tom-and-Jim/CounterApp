//
//  CounterClientLive.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/21.
//

import ComposableArchitecture

extension CounterClient.Interface {
    static var live: Self {
        .init(
            increment: { value, max in
                let newValue = value + 1
                return newValue > max ? Effect(error: .maxBoundReached) : Effect(value: newValue)
            },
            decrement: { value, min in
                let newValue = value - 1
                return newValue < min ? Effect(error: .minBoundReached) : Effect(value: newValue)
            }
        )
    }
}
