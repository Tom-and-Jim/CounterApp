//
//  EditUserCore.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/20.
//

import Foundation
import ComposableArchitecture

struct EditUserState: Equatable {
    @BindableState var user: User
}

enum EditUserAction: Equatable, BindableAction {
    case binding(BindingAction<EditUserState>)
    case save
    case dismiss
    case didSave(User)
}

let editUserReducer = Reducer<EditUserState, EditUserAction, UserClient.Interface> { state, action, _ in
    switch action {
    case .save:
        return Effect(value: .didSave(state.user))
        
    case .dismiss,
         .binding,
         .didSave:
        return .none
    }
}
.binding()
