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
                Text("First name: \(viewStore.user.user.firstName)").padding()
                Text("Last name: \(viewStore.user.user.lastName)").padding()
                Text("Email: \(viewStore.user.user.email)").padding()
                Text("Age: \(viewStore.user.user.age)").padding()
                Text("Job: \(viewStore.user.user.job)").padding()
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
                EditUserView(
                    store: store.scope(
                        state: \.user,
                        action: UserDetailAction.editUserView),
                    editingUser: viewStore.user.user.copy()
                )
            }
        }
    }
}
