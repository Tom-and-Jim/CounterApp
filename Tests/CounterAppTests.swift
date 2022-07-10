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
    let mainQueue = DispatchQueue.test
    var testStore: TestStore<AppState, AppState, AppAction, AppAction, AppEnvironment>!

    override func setUp() {
        testStore = TestStore(
            initialState: AppState(counter: CounterState(count: 0, errorMessage: nil)),
            reducer: APP_REDUCER,
            environment: AppEnvironment(
                mainQueue: mainQueue.eraseToAnyScheduler(),
                increment: { count, max in
                    count + 1 < max ? Effect(value: count + 1) : Effect(error: ApiError())
                },
                decrement: { count, min in
                    count - 1 > min ? Effect(value: count - 1) : Effect(error: ApiError())
                }
            )
        )
    }

    func testCounterIncLocal() {
        testStore.send(AppAction.counter(CounterView.Action.incrementButtonTapped.feature)) {
            $0.counter.count = 1
        }
    }

    func testCounterDecLocal() {
        testStore.send(AppAction.counter(CounterView.Action.decrementButtonTapped.feature)) {
            $0.counter.count = -1
        }
    }


    func testCounterIncFetch() {
        testStore.send(AppAction.counter(CounterView.Action.incrementButtonTappedFetch(2).feature))
        mainQueue.advance()
        testStore.receive(AppAction.counter(.numberChangeResponse(.success(1)))) {
            $0.counter.count = 1
        }
        
        testStore.send(AppAction.counter(CounterView.Action.incrementButtonTappedFetch(2).feature))
        mainQueue.advance()
        testStore.receive(AppAction.counter(.numberChangeResponse(.failure(ApiError())))) {
            $0.counter.count = 1
            $0.counter.errorMessage = "Sorry, you are out of range."
        }
    }

    func testCounterDecFetch() {
        testStore.send(AppAction.counter(CounterView.Action.decrementButtonTappedFetch(-2).feature))
        mainQueue.advance()
        testStore.receive(AppAction.counter(.numberChangeResponse(.success(-1)))) {
            $0.counter.count = -1
        }
        
        testStore.send(AppAction.counter(CounterView.Action.decrementButtonTappedFetch(-2).feature))
        mainQueue.advance()
        testStore.receive(AppAction.counter(.numberChangeResponse(.failure(ApiError())))) {
            $0.counter.count = -1
            $0.counter.errorMessage = "Sorry, you are out of range."
        }
    }
}
