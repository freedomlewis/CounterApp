//
//  UserInfoCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/22.
//

import ComposableArchitecture

struct UserInfoState: Equatable {
    var user: User
    var disabled: Bool = false
}

enum UserInfoAction: Equatable {
    case firstNameChanged(String)
    case lastNameChanged(String)
    case emailChanged(String)
    case ageChanged(String)
    case jobChanged(String)
}

let userInfoReducer = Reducer<UserInfoState, UserInfoAction, UserInfoEnvironment> { state, action, _ in
    switch action {
    case let .firstNameChanged(firstName):
        state.user.firstName = firstName
        return .none
        
    case let .lastNameChanged(lastName):
        state.user.lastName = lastName
        return .none
        
    case let .emailChanged(email):
        state.user.email = email
        return .none
        
    case let .ageChanged(age):
        state.user.age = Int(age) ?? 0
        return .none
        
    case let .jobChanged(job):
        state.user.job = job
        return .none
    }
}

struct UserInfoEnvironment {}
