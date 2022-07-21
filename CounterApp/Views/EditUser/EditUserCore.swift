//
//  EditUserCore.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/20.
//

import Foundation
import ComposableArchitecture

struct UserState: Equatable {
    var firstName: String
    var lastName: String
    var email: String
    var age: Int
    var job: String
}

enum UserAction: Equatable {
    case updateFirstName(String)
    case updateLastName(String)
    case updateEmail(String)
    case updateAge(String)
    case updateJob(String)
}

struct UserEnvironment {}

let userReducer = Reducer<UserState, UserAction, UserEnvironment> { state, action, environment in
    switch action {
    case .updateFirstName(let firstName):
        state.firstName = firstName
        return .none
    case .updateLastName(let LastName):
        state.lastName = LastName
        return .none
    case .updateEmail(let email):
        state.email = email
        return .none
    case .updateAge(let age):
        state.age = Int(age) ?? 0
        return .none
    case .updateJob(let job):
        state.job = job
        return .none
    }
}
