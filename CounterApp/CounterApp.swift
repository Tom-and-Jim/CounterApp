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
    var body: some Scene {
        WindowGroup {
            AppView(store: appStore)
        }
    }
}