//
//  EditUserCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import ComposableArchitecture

struct EditUserState: Equatable {
    var user: User
}

enum EditUserAction: Equatable {
    case firstNameChanged(String)
    case lastNameChanged(String)
    case emailChanged(String)
    case ageChanged(String)
    case jobChanged(String)
    case onSaveTapped
    case onCancelTapped
}

struct EditUserEnvironment {}

let editUserReducer = Reducer<EditUserState, EditUserAction, EditUserEnvironment> { state, action, _ in
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
        
    default:
        return .none
    }
}
