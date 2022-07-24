//
//  MainView.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/12.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: Store<RootState, RootAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                NavigationLink(
                    "CounterView",
                    isActive: viewStore.binding(
                        get: \.counterActive,
                        send: RootAction.setCounterActive
                    ),
                    destination: {
                        CounterView(
                            store: store.scope(
                                state: \.counter,
                                action: RootAction.counter
                            )
                        )
                    }
                )
                .padding()

                Button("LockView") {
                    viewStore.send(.setLockActive(true))
                }
                .sheet(isPresented:
                        viewStore.binding(
                            get: \.lockActive,
                            send: RootAction.setLockActive
                        )
                ) {
                    LockView(store: store.scope(state: \.lock, action: RootAction.lock))
                }
                .padding()

                NavigationLink(
                    "UsersView",
                    isActive: viewStore.binding(
                        get: \.usersActive,
                        send: RootAction.setUsersActive
                    ),
                    destination: {
                        IfLetStore(
                            store.scope(
                                    state: \.users,
                                    action: RootAction.users
                                ),
                            then: UsersView.init
                        )
                    }
                )
                .padding()
            }
        }
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView(store: appStore.scope(state: \.root, action: AppAction.rootView))
//    }
//}
