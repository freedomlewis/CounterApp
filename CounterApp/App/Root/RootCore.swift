//
//  RootCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import ComposableArchitecture

struct RootState: Equatable {
    var counter: Int = 0
    var counterDetail: CounterDetailState?
    var lock: LockState?
    var users: UsersState?
}

enum RootAction: Equatable {
    case counterDetail(CounterDetailAction)
    case lock(LockAction)
    case users(UsersAction)
    case activeCounterDetail
    case resetCounterDetail
    case activeLock
    case resetLock
    case activeUsers
    case resetUsers
    case resetUsersComplete
}

let rootReducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
    counterDetailReducer
        .optional()
        .pullback(
            state: \.counterDetail,
            action: /RootAction.counterDetail,
            environment: \.counterDetail
        ),
    
    lockReducer
        .optional()
        .pullback(
            state: \.lock,
            action: /RootAction.lock,
            environment: \.lock
        ),
    
    usersReducer
        .optional()
        .pullback(
            state: \.users,
            action: /RootAction.users,
            environment: \.users
        ),
    Reducer { state, action, env in
        enum CancelId{}
        
        switch action {
        case .activeCounterDetail:
            state.counterDetail = .init(
                counter: CounterState(count: state.counter, min: -10, max: 10)
            )
            return .none
            
        case .resetCounterDetail:
            state.counterDetail = nil
            return .none
            
        case .activeLock:
            state.lock = .init(code: [9, 5, 7])
            return .none
            
        case .resetLock:
            state.lock = nil
            return .none
            
        case .activeUsers:
            state.users = .init(userNum: 16)
            return .cancel(id: CancelId.self)

        case .resetUsers:
            // delay for the userReducer cancel the randomGenerator with the onDisappear action
            return Effect(value: .resetUsersComplete)
                .delay(for: 0.1, scheduler: DispatchQueue.main)
                .eraseToEffect()
                .cancellable(id: CancelId.self)
        
        case .resetUsersComplete:
            state.users = nil
            return .none
            
        case let .counterDetail(.didSetValue(value)):
            state.counter = value
            return .none
            
        default:
            return .none
        }
    }
).debug()

struct RootEnvironment {
    let counterEnv: CounterEnviroment
    let firstNameGenerator: RandomGenerator.GenerateFirstName
    let cancelNameGenrator: RandomGenerator.CancelFirstNameGenerator
}

extension RootEnvironment {
    var counterDetail: CounterDetailEnviroment {
        .init(counter: counterEnv)
    }
    
    var lock: LockEnvironment {
        .init(counter: counterEnv)
    }
    
    var users: UsersEnvironment {
        .init(
            randomFirstName: firstNameGenerator,
            cancelGenerator: cancelNameGenrator
        )
    }
}
