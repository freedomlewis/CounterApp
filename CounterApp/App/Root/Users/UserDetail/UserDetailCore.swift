//
//  UserDetailCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import ComposableArchitecture

struct UserDetailState: Equatable {
    var userInfo: UserInfoState
    var editUserState: EditUserState?
}

enum UserDetailAction: Equatable {
    case userInfoView(UserInfoAction)
    case edit(EditUserAction)
    case activeEdit
    case deActiveEdit
    case userInfoChanged(User)
}

let userDetailReducer = Reducer<UserDetailState, UserDetailAction, UserDetailEnvironment>.combine(
    userInfoReducer
        .pullback(
            state: \.userInfo,
            action: /UserDetailAction.userInfoView,
            environment: \.userInfo
        ),
    
    editUserReducer
        .optional()
        .pullback(
            state: \.editUserState,
            action: /UserDetailAction.edit,
            environment: \.editUser
        ),
    
    Reducer { state, action, _ in
        switch action {
        case .activeEdit:
            var editUserInfo = state.userInfo
            editUserInfo.disabled = false
            state.editUserState = EditUserState(userInfo: editUserInfo)
            return .none
            
        case .deActiveEdit:
            state.editUserState = nil
            return .none
            
        case .edit(.cancelSaveUser):
            return Effect(value: .deActiveEdit)
        
        case let .edit(.didSaveUser(user)):
            state.userInfo.user = user
            state.editUserState = nil
            return Effect(value: .userInfoChanged(user))
            
        default:
            return .none
        }
    }
)

struct UserDetailEnvironment {
    var userInfo: UserInfoEnvironment
}

extension UserDetailEnvironment {
    var editUser: EditUserEnvironment {
        .init(userInfo: UserInfoEnvironment())
    }
}
