//
//  LockCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/12.
//

import ComposableArchitecture
import Foundation

struct LockState: Equatable {
    var counters: IdentifiedArrayOf<CounterState> = []
    var isPresent: Bool = false
}

enum LockAction: Equatable {
    case counter(id: CounterState.ID, action: CounterAction)
    case setSheet(isPresented: Bool)
}

struct LockEnvironment {}

let lockReducer: Reducer<LockState, LockAction, LockEnvironment> =
    counterReducer.forEach(
        state: \.counters,
        action: /LockAction.counter(id:action:),
        environment: { _ in CounterEnviroment.defaultEnv() }
    ).combined(with: Reducer { state, action, _ in
        switch action {
        case let .setSheet(isPresented):
            state.isPresent = isPresented
            return .none

        default:
            return .none
        }
    })
