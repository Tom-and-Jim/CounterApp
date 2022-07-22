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
    var user: EditUserState
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
    editUserReducer.pullback(
        state: \.user,
        action: /UserDetailAction.editUserView,
        environment: { $0.user }
    ),
    Reducer { state, action, _ in
        switch action {
        case let .setEditUserActive(active):
            state.editUserActive = active
            return .none
        case .editUserView(.dismiss):
            state.editUserActive = false
            return .none
        default:
            return .none
        }
    }
)


