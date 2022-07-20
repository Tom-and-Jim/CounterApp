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
//                    NavigationLink("CounterView") {
//                        // This behaves normal.
////                        CounterView(store: .init(
////                            initialState: viewStore.counter,
////                            reducer: counterReducer,
////                            environment: counterEnvironment
////                        ))
//
//                        // This will cause the bug.
//                        CounterView(store: store.scope(state: \.counter, action: AppAction.counter))
//                    }
//                    .padding()

                    NavigationLink(
                        "CounterView",
                        isActive: viewStore.binding(
                            get: \.counterActive,
                            send: AppAction.setCounterActive
                        ),
                        destination: {
                            CounterView(
                                store: store.scope(
                                    state: \.counter,
                                    action: AppAction.counter
                                )
                            )
                        }
                    )
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
