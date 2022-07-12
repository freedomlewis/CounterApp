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

struct AppEnviroment {}

let appReducer = Reducer<AppState, AppAction, AppEnviroment>.combine(
    counterReducer.pullback(
        state: \AppState.counter,
        action: /AppAction.counter,
        environment: { _ in CounterEnviroment.defaultEnv() }
    ),
    lockReducer.pullback(
        state: \AppState.lock,
        action: /AppAction.lock,
        environment: { _ in LockEnvironment.defaultEnv() }
    ),
    Reducer { _, action, _ in
        switch action {
        default:
            return .none
        }
    }
).debug()

let appStore = Store(
    initialState: AppState(
        counter: CounterState(),
        lock: LockState(
            counters: [
                CounterState(count: 0),
                CounterState(count: 5),
                CounterState(count: 9)
            ]
        )
    ),
    reducer: appReducer,
    environment: AppEnviroment()
)
