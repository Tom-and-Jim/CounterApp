//
//  CounterAppApp.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/8.
//

import SwiftUI

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(store: APP_STORE.scope(state: \.counter, action: AppAction.counter))
        }
    }
}
