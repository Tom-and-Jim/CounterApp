//
//  CountAppTest.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/8.
//

import ComposableArchitecture
import XCTest
@testable import CounterApp

class CounterAppTests: XCTestCase {
    let scheduler = DispatchQueue.test
    var testStore: TestStore<AppState, AppState, AppAction, AppAction, AppEnvironment>!

    override func setUp() {
        testStore = TestStore(
            initialState: AppState(counter: CounterState(id: UUID(), count: 0, errorMessage: nil)),
            reducer: appReducer,
            environment: AppEnvironment(
                counter: CounterEnvironment(
                    mainQueue: scheduler.eraseToAnyScheduler(),
                    increment: { count, max in
                        count + 1 < max ? Effect(value: count + 1) : Effect(error: ApiError())
                    },
                    decrement: { count, min in
                        count - 1 > min ? Effect(value: count - 1) : Effect(error: ApiError())
                    }
                )
            )
        )
    }

    func testCounterIncFetch() {
        testStore.send(AppAction.counter(EditCounterView.Action.incrementButtonTappedFetch(2).feature))
        scheduler.advance()
        testStore.receive(AppAction.counter(.numberChangeResponse(.success(1)))) {
            $0.counter.count = 1
        }
        
        testStore.send(AppAction.counter(EditCounterView.Action.incrementButtonTappedFetch(2).feature))
        scheduler.advance()
        testStore.receive(AppAction.counter(.numberChangeResponse(.failure(ApiError())))) {
            $0.counter.count = 1
            $0.counter.errorMessage = "Sorry, you are out of range."
        }
    }

    func testCounterDecFetch() {
        testStore.send(AppAction.counter(EditCounterView.Action.decrementButtonTappedFetch(-2).feature))
        scheduler.advance()
        testStore.receive(AppAction.counter(.numberChangeResponse(.success(-1)))) {
            $0.counter.count = -1
        }
        
        testStore.send(AppAction.counter(EditCounterView.Action.decrementButtonTappedFetch(-2).feature))
        scheduler.advance()
        testStore.receive(AppAction.counter(.numberChangeResponse(.failure(ApiError())))) {
            $0.counter.count = -1
            $0.counter.errorMessage = "Sorry, you are out of range."
        }
    }
}
