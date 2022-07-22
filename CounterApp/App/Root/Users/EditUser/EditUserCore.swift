//
//  EditUserCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import ComposableArchitecture

struct EditUserState: Equatable {
    var userInfo: UserInfoState
}

enum EditUserAction: Equatable {
    case userInfoView(UserInfoAction)
    case onSaveTapped
    case onCancelTapped
}

struct EditUserEnvironment {
    var userInfo: UserInfoEnvironment
}

let editUserReducer = Reducer<EditUserState, EditUserAction, EditUserEnvironment>.combine(
    userInfoReducer.pullback(state: \.userInfo, action: /EditUserAction.userInfoView, environment: \.userInfo),
    Reducer{ state, action, _ in
        switch action {
        case .onSaveTapped:
            return .none
        case .onCancelTapped:
            return .none
        default:
            return .none
        }
    }
)
