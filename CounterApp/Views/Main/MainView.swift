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
    @State private var showLock = false
    
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

                    Button("LockView") {
                        showLock.toggle()
                    }
                    .sheet(isPresented: $showLock) {
                        LockView(store: store.scope(state: \.lock, action: AppAction.lock))
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
