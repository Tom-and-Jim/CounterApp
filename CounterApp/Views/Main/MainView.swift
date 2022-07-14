//
//  MainView.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/12.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    NavigationLink("CounterView") {
                        CounterView(store: .init(
                            initialState: viewStore.counter,
                            reducer: counterReducer,
                            environment: counterEnvironment
                        ))
                    }
                    .padding()
                    
                    NavigationLink("LockView") {
                        LockView(store: store)
                    }
                    .padding()
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(store: appStore)
    }
}
