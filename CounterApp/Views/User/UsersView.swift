//
//  UsersView.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/20.
//

import SwiftUI
import ComposableArchitecture

struct UserItemView: View {
    let store: Store<User, Never>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                Text("First name: \(viewStore.firstName)")
                .padding()

                Text("Last name: \(viewStore.lastName)")
                .padding()

                Text("Email: \(viewStore.email)")
                .padding()
            }
            .navigationTitle("User list")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct UsersView: View {
    let store: Store<UsersState, UsersAction>

    var body: some View {
        WithViewStore(store) { parentViewStore in
            List {
                ForEachStore(store.scope(state: \.users, action: UsersAction.usersView)) { childStore in
                    WithViewStore(childStore) { viewStore in
                        NavigationLink(
                            tag: viewStore.id,
                            selection: parentViewStore.binding(
                                get: \.userDetailSelection,
                                send: UsersAction.setUserDetailSelection
                            ),
                            destination: {
                                UserDetailView(store: childStore)
                            },
                            label: {
                                UserItemView(
                                    store: childStore.scope(state: \.user).actionless
                                )
                            }
                        )
                    }
                }
            }
        }
    }
}
