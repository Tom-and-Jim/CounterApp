//
//  EditUserCore.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/20.
//

import Foundation
import ComposableArchitecture

struct EditUserState: Equatable {
    var user: User
}

enum EditUserAction: Equatable {
    case updateUser(User)
    case dismiss
}

let editUserReducer = Reducer<EditUserState, EditUserAction, UserClient.Interface> { state, action, _ in
    switch action {
    case .updateUser(let newUser):
        state.user = newUser
        return .none
    case .dismiss:
        return .none
    }
}
