//
//  UserDetailCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import ComposableArchitecture

struct UserDetailState: Equatable {
    var user: User
    var editUserState: EditUserState?
}

enum UserDetailAction: Equatable {
    case edit(EditUserAction)
    case activeEdit
    case deActiveEdit
}

let userDetailReducer = Reducer<UserDetailState, UserDetailAction, UserDetailEnvironment>.combine(
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
            state.editUserState = EditUserState(user: state.user)
            return .none
            
        case .deActiveEdit:
            state.editUserState = nil
            return .none
            
        case .edit(.onSaveTapped):
            guard let editUser = state.editUserState?.user else {
                return .none
            }
            state.user = editUser
            return Effect(value: .deActiveEdit)
        
        case .edit(.onCancelTapped):
            return Effect(value: .deActiveEdit)
            
        default:
            return .none
        }
    }
)

struct UserDetailEnvironment {}

extension UserDetailEnvironment {
    var editUser: EditUserEnvironment {
        .init(userInfo: UserInfoEnvironment())
    }
}
