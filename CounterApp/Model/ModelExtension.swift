//
//  ModelExtension.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/22.
//

import Foundation

extension User {
    func copy() -> Self {
        .init(
            firstName: self.firstName,
            lastName: self.lastName,
            email: self.email,
            age: self.age,
            job: self.job
        )
    }
}
