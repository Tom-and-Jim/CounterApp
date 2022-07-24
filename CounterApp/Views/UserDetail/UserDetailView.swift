//
//  UserDetailView.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/20.
//

import SwiftUI
import ComposableArchitecture

struct UserDetailView: View {
    let store: Store<UserDetailState, UserDetailAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading, spacing: 5) {
                Group {
                    Text("First name: \(viewStore.user.firstName)")
                    Text("Last name: \(viewStore.user.lastName)")
                    Text("Email: \(viewStore.user.email)")
                    Text("Age: \(viewStore.user.age)")
                    Text("Job: \(viewStore.user.job)")
                }
                .padding()
            }
            .navigationTitle("User detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        viewStore.send(.setEditUserActive(true))
                    }
                }
            }
            .sheet(isPresented:
                    viewStore.binding(
                        get: \.editUserActive,
                        send: UserDetailAction.setEditUserActive
                    )
            ) {
                IfLetStore(
                    store.scope(
                        state: \.editUserState,
                        action: UserDetailAction.editUserView),
                    then: EditUserView.init
                )
            }
        }
    }
}
