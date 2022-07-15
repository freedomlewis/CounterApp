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
    var unlockAlert: AlertState<LockAction>?
}

enum LockAction: Equatable {
    case counter(id: CounterState.ID, action: CounterAction)
    case alertDismissed
}

struct LockEnvironment {
    var counter: CounterEnviroment
}

let lockReducer: Reducer<LockState, LockAction, LockEnvironment> =
    counterReducer.forEach(
        state: \.counters,
        action: /LockAction.counter(id:action:),
        environment: \.counter
    ).combined(with: Reducer { state, action, env in
        switch action {
        case let .counter(id: id, action: .counterResponse(.success(value))):
            if state.counters.map(\.count) == [9, 5, 7] {
                state.unlockAlert = .init(title: .init("Unlocked!"))
            }
            return .none

        case .alertDismissed:
            state.unlockAlert = nil
            return .none

        default:
            return .none
        }
    })
