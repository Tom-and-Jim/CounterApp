//
//  UsersExtension.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/22.
//

import Foundation

extension UsersState {
    static func fake() -> Self {
        UsersState(
            users: [
                UserDetailState(
                    id: UUID(),
                    user: User(firstName: "f1", lastName: "l1", email: "e1", age: 1, job: "j1"),
                    editUserActive: false
                ),
                UserDetailState(
                    id: UUID(),
                    user: User(firstName: "f2", lastName: "l2", email: "e2", age: 2, job: "j2"),
                    editUserActive: false
                )
            ]
        )
    }
}
