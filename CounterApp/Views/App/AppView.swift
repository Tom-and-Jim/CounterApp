//
//  AppView.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/21.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        NavigationView {
            RootView(store:
                        store.scope(
                            state: \.root,
                            action: AppAction.rootView
                        )
            )
        }
        .navigationViewStyle(.stack)
    }
}
