//
//  CounterAppApp.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/8.
//

import SwiftUI
import ComposableArchitecture

@main
struct CounterApp: App {
    let store = Store<AppState, AppAction>(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment()
    )
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}
