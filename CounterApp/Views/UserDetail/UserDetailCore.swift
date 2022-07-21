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
    var user: UserState
    var editUserActive: Bool
}

enum UserDetailAction: Equatable {
    case setEditUserActive(Bool)
    case editUserView(UserAction)
}

struct UserDetailEnvironment {
    var user: UserEnvironment
}

let userDetailReducer: Reducer<UserDetailState, UserDetailAction, UserDetailEnvironment> = .combine(
    Reducer { state, action, _ in
        print("userDetailReducer")
        switch action {
        case let .setEditUserActive(active):
            print("setEditUserActive \(active)")
            state.editUserActive = active
            return .none
        default:
            return .none
        }
    }
)


