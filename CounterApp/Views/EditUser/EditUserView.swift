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
    let store: Store<EditUserState, EditUserAction>
    @State var editingUser: User

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Button("Cancel") {
                        viewStore.send(.dismiss)
                    }
                    .padding()

                    Spacer()

                    Button("Save") {
                        viewStore.send(.updateUser(editingUser))
                        viewStore.send(.dismiss)
                    }
                    .padding()
                }
                Spacer()
                HStack {
                    Text("First name:")
                    Spacer()
                    TextField(
                        "First name",
                        text: $editingUser.firstName
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
                        text: $editingUser.lastName
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
                        text: $editingUser.email
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
                        value: $editingUser.age,
                        formatter: NumberFormatter()
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
                        text: $editingUser.job
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
