//
//  UserInfoCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/22.
//

import ComposableArchitecture

struct UserInfoState: Equatable {
    @BindableState var user: User
}

enum UserInfoAction: BindableAction, Equatable {
    case binding(BindingAction<UserInfoState>)
}

let userInfoReducer = Reducer<UserInfoState, UserInfoAction, UserInfoEnvironment> { state, action, _ in
    switch action {
    case .binding:
        return .none
    }
}.binding()

struct UserInfoEnvironment {}
