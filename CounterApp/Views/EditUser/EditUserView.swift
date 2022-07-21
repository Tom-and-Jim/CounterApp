//
//  EditUserView.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/20.
//

import SwiftUI
import Combine
import ComposableArchitecture

struct EditUserView: View {
    let store: Store<UserState, UserAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Text("First name:")
                    Spacer()
                    TextField(
                        "First name",
                        text: viewStore.binding(get: \.firstName, send: UserAction.updateFirstName)
                    )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                        .padding()
                }
                .padding()

                HStack {
                    Text("Last name:")
                    Spacer()
                    TextField(
                        "Last name",
                        text: viewStore.binding(get: \.lastName, send: UserAction.updateLastName)
                    )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                        .padding()
                }
                .padding()

                HStack {
                    Text("Email:")
                    Spacer()
                    TextField(
                        "Email",
                        text: viewStore.binding(get: \.email, send: UserAction.updateEmail)
                    )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                        .padding()
                }
                .padding()

                HStack {
                    Text("Age:")
                    Spacer()
                    TextField(
                        "Age",
                        text: viewStore.binding(get: { userState in "\(userState.age)" }, send: UserAction.updateAge)
                    )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                        .padding()
                        .keyboardType(UIKeyboardType.numberPad)
                }
                .padding()

                HStack {
                    Text("Job:")
                    Spacer()
                    TextField(
                        "Job",
                        text: viewStore.binding(get: \.job, send: UserAction.updateJob)
                    )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                        .padding()
                }
                .padding()
            }
        }
    }
}

//struct EditUserView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditUserView(store: .init(
//            initialState: UserState(id: UUID(), firstName: "f1", lastName: "l1", email: "e1", age: 1, job: "j1"),
//            reducer: Reducer<UserState, UserAction, UserEnvironment> { _,_,_ in return .none },
//            environment: UserEnvironment()
//        )
//        )
//    }
//}
