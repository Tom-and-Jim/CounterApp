//
//  UserDetailCore.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/20.
//

import Foundation
import ComposableArchitecture

struct UserDetailState: Equatable, Identifiable {
    let id: UUID
    var user: User
    var editUserState: EditUserState?
    var editUserActive: Bool
}

enum UserDetailAction: Equatable {
    case setEditUserActive(Bool)
    case editUserView(EditUserAction)
}

struct UserDetailEnvironment {
    var user: UserClient.Interface
}

let userDetailReducer: Reducer<UserDetailState, UserDetailAction, UserDetailEnvironment> = .combine(
    editUserReducer.optional().pullback(
        state: \.editUserState,
        action: /UserDetailAction.editUserView,
        environment: { $0.user }
    ),
    Reducer { state, action, _ in
        switch action {
        case let .setEditUserActive(active):
            state.editUserActive = active
            state.editUserState = .init(user: state.user)
            return .none
        case .editUserView(.dismiss):
            state.editUserActive = false
            return .none
        case let .editUserView(.didSave(user)):
            state.user = user
            return .none
        default:
            return .none
        }
    }
)


