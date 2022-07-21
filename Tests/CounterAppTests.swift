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
    var testStore: TestStore<RootState, RootState, RootAction, RootAction, RootEnvironment>!

    override func setUp() {
        testStore = TestStore(
            initialState: RootState(counter: CounterState(id: UUID(), count: 0, errorMessage: nil)),
            reducer: rootReducer,
            environment: RootEnvironment(
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
        testStore.send(RootAction.counter(EditCounterView.Action.incrementButtonTappedFetch(2).feature))
        scheduler.advance()
        testStore.receive(RootAction.counter(.numberChangeResponse(.success(1)))) {
            $0.counter.count = 1
        }
        
        testStore.send(RootAction.counter(EditCounterView.Action.incrementButtonTappedFetch(2).feature))
        scheduler.advance()
        testStore.receive(RootAction.counter(.numberChangeResponse(.failure(ApiError())))) {
            $0.counter.count = 1
            $0.counter.errorMessage = "Sorry, you are out of range."
        }
    }

    func testCounterDecFetch() {
        testStore.send(RootAction.counter(EditCounterView.Action.decrementButtonTappedFetch(-2).feature))
        scheduler.advance()
        testStore.receive(RootAction.counter(.numberChangeResponse(.success(-1)))) {
            $0.counter.count = -1
        }
        
        testStore.send(RootAction.counter(EditCounterView.Action.decrementButtonTappedFetch(-2).feature))
        scheduler.advance()
        testStore.receive(RootAction.counter(.numberChangeResponse(.failure(ApiError())))) {
            $0.counter.count = -1
            $0.counter.errorMessage = "Sorry, you are out of range."
        }
    }
}
