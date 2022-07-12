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
    var isShowLockView: Bool = false
}

enum AppAction: Equatable {
    case counter(CounterAction)
    case lock(LockAction)
    case setSheet(isPresented: Bool)
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
        environment: { _ in LockEnvironment() }
    ),
    Reducer { state, action, _ in
        switch action {
        case let .setSheet(isPresented):
            state.isShowLockView = isPresented
            return .none

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
