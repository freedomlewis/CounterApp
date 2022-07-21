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
}

let rootReducer = Reducer<RootState, RootAction, RootEnviroment>.combine(
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
            state.users = nil
            return .none
            
        default:
            return .none
        }
    }
).debug()

struct RootEnviroment {
    let counter = defaultCounterEnv
    let lock = LockEnvironment(counter: defaultCounterEnv)
    let users = UsersEnvironment(randomFirstName: randomGeneratorLive.generateFirstName)
    
    private static let randomGeneratorLive = RandomGenerator.Interface.live
    private static let defaultCounterEnv = CounterEnviroment(
        queue: DispatchQueue.main.eraseToAnyScheduler(),
        increment: { value, max in
            if value < max {
                return Effect(value: value + 1)
            } else {
                return Effect(error: ServiceError(msg: "Inc failed: greater than max \(max)"))
            }
        }, decrement: { value, min -> Effect<Int, ServiceError> in
            if value > min {
                return Effect(value: value - 1)
            } else {
                return Effect(error: ServiceError(msg: "Dec falied: lower than min \(min)"))
            }
        }
    )
}
