//
//  AppCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/12.
//

import ComposableArchitecture
import Foundation

struct AppState: Equatable {
    var counter: CounterState
    var lock: LockState
}

enum AppAction: Equatable {
    case counter(CounterAction)
    case lock(LockAction)
}

struct AppEnviroment {
    let counter = defaultCounterEnv
    let lock = LockEnvironment(counter: defaultCounterEnv)
    
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

let appReducer = Reducer<AppState, AppAction, AppEnviroment>.combine(
    counterReducer.pullback(
        state: \.counter,
        action: /AppAction.counter,
        environment: \.counter
    ),
    lockReducer.pullback(
        state: \.lock,
        action: /AppAction.lock,
        environment: \.lock
    )
).debug()
