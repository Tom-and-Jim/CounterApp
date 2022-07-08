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
    let state = AppState(count: 0, errorMessage: nil)
    let mainQueue = DispatchQueue.test
    var testStore: TestStore<AppState, AppState, AppAction, AppAction, AppEnvironment>!
    
    override func setUp() {
        testStore = TestStore(
            initialState: AppState(),
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
        testStore.send(.incrementButtonTapped) {
            $0.count = 1
        }
    }
    
    func testCounterDecLocal() {
        testStore.send(.decrementButtonTapped) {
            $0.count = -1
        }
    }


    func testCounterIncFetch() {
        testStore.send(.incrementButtonTappedFetch(2))
        mainQueue.advance()
        testStore.receive(.numberChangeResponse(.success(1))) {
            $0.count = 1
        }
        
        testStore.send(.incrementButtonTappedFetch(2))
        mainQueue.advance()
        testStore.receive(.numberChangeResponse(.failure(ApiError()))) {
            $0.count = 1
            $0.errorMessage = "Sorry, you are out of range."
        }
    }
    
    func testCounterDecFetch() {
        testStore.send(.decrementButtonTappedFetch(-2))
        mainQueue.advance()
        testStore.receive(.numberChangeResponse(.success(-1))) {
            $0.count = -1
        }
        
        testStore.send(.decrementButtonTappedFetch(-2))
        mainQueue.advance()
        testStore.receive(.numberChangeResponse(.failure(ApiError()))) {
            $0.count = -1
            $0.errorMessage = "Sorry, you are out of range."
        }
    }
}
