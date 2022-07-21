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
                Text("First name: \(viewStore.user.firstName)").padding()
                Text("Last name: \(viewStore.user.lastName)").padding()
                Text("Email: \(viewStore.user.email)").padding()
                Text("Age: \(viewStore.user.age)").padding()
                Text("Job: \(viewStore.user.job)").padding()

                Button("Edit") {
                    print("viewStore.send(.setEditUserActive(true))")
                    viewStore.send(.setEditUserActive(true))
                }
            }
            .navigationTitle("User detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(
//                        destination: {
//                            EditUserView(store: store.scope(state: \.user, action: UserDetailAction.editUserView))
//                        },
//                        label: {
//                            Text("Edit")
//                        }
//                    )

                    Button("Edit") {
                        print("viewStore.send(.setEditUserActive(true))")
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
                EditUserView(store: store.scope(state: \.user, action: UserDetailAction.editUserView))
            }
        }
    }
}

//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailView(store:
//                            .init(
//                                initialState: UserState(id: UUID(), firstName: "f1", lastName: "l1", email: "e1", age: 1, job: "j1"),
//                                reducer: Reducer<UserState, UserAction, UserEnvironment> { _,_,_ in return .none },
//                                environment: UserEnvironment()
//                            )
//        )
//    }
//}
