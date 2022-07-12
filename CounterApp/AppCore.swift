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
}

enum AppAction: Equatable {
    case counter(CounterAction)
}

struct AppEnviroment {
    let counterEnv = CounterEnviroment(
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

let appReducer: Reducer<AppState, AppAction, AppEnviroment> = .combine(
    counterReducer.pullback(
        state: \AppState.counter,
        action: /AppAction.counter,
        environment: { env in env.counterEnv }
    )
).debug()
