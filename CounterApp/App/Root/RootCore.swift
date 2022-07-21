//
//  RootCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import ComposableArchitecture

struct RootState: Equatable {
    var counter: CounterState?
    var lock: LockState?
    var users: UsersState?
}

enum RootAction: Equatable {
    case counter(CounterAction)
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
    counterReducer
        .optional()
        .pullback(
            state: \.counter,
            action: /RootAction.counter,
            environment: \.counter
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
    Reducer { state, action, _ in
        switch action {
        case .activeCounterDetail:
            state.counter = .init()
            return .none
            
        case .resetCounterDetail:
            state.counter = nil
            return .none
            
        case .activeLock:
            state.lock = .init(code: [9, 5, 7])
            return .none
            
        case .resetLock:
            state.lock = nil
            return .none
            
        case .activeUsers:
            state.users = .init()
            return .none

        case .resetUsers:
            // delay for the userReducer cancel the randomGenerator with the onDisappear action
            return Effect(value: .resetUsersComplete)
                .delay(for: 1, scheduler: DispatchQueue.main)
                .eraseToEffect()
        
        case .resetUsersComplete:
            state.users = nil
            return .none
            
        default:
            return .none
        }
    }
).debug()

struct RootEnvironment {
    let counterEnv: CounterEnviroment
    let firstNameGenerator: RandomGenerator.GenerateFirstName
}

extension RootEnvironment {
    var counter: CounterEnviroment {
        counterEnv
    }
    
    var lock: LockEnvironment {
        .init(counter: counterEnv)
    }
    
    var users: UsersEnvironment {
        .init(randomFirstName: firstNameGenerator)
    }
}
