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
                        viewStore.send(.save)
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
                        text: viewStore.binding(\.$user.firstName)
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
                        text: viewStore.binding(\.$user.lastName)
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
                        text: viewStore.binding(\.$user.email)
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
                        value: viewStore.binding(\.$user.age),
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
                        text: viewStore.binding(\.$user.job)
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
