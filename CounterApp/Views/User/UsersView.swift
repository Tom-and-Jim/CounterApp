//
//  UsersView.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/20.
//

import SwiftUI
import ComposableArchitecture

struct UserItemView: View {
    let store: Store<UserState, Never>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Text("First name: \(viewStore.firstName)")
                    Spacer()
                    Text("Last name: \(viewStore.lastName)")
                }
                .padding()

                HStack {
                    Text("Email: \(viewStore.email)")
                    Spacer()
                }
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
                ForEachStore(store.scope(state: \.users, action: UsersAction.usersView)) { viewStore in
                    // This can not navigate to UserDetailView.
//                    NavigationLink(
//                        isActive: parentViewStore.binding(
//                            get: \.userDetailActive,
//                            send: UsersAction.setUserDetailActive
//                        ),
//                        destination: {
//                            UserDetailView(store: viewStore)
//                        },
//                        label: {
//                            UserItemView(store: viewStore)
//                        }
//                    )

                    NavigationLink(
                        destination: {
                            UserDetailView(store: viewStore)
                        },
                        label: {
                            UserItemView(store: viewStore.scope(state: \.user).actionless)
                        }
                    )
                }
            }
        }
    }
}

//struct UsersView_Previews: PreviewProvider {
//    static var previews: some View {
//        UsersView(store:
//                        .init(
//                            initialState:
//                                UsersState(users:
//                                                [
//                                                    UserState(id: UUID(), firstName: "f1", lastName: "l1", email: "e1", age: 1, job: "j1"),
//                                                    UserState(id: UUID(), firstName: "f2", lastName: "l2", email: "e2", age: 2, job: "j2")
//                                                ],
//                                           userDetailActive: false
//                                            ),
//                            reducer: Reducer<UsersState, UsersAction, UsersEnvironment> { _,_,_ in
//                                return .none
//                            },
//                            environment: UsersEnvironment(user: UserEnvironment(), mainQueue: .main)
//                        )
//        )
//    }
//}

