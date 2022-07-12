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
    var unlockAlert: AlertState<LockAction>?
}

enum LockAction: Equatable {
    case counter(id: CounterState.ID, action: CounterAction)
    case setSheet(isPresented: Bool)
    case alertDismissed
}

struct LockEnvironment {
    var tryToUnlock: (IdentifiedArrayOf<CounterState>) -> Bool

    static func defaultEnv() -> LockEnvironment {
        LockEnvironment(tryToUnlock: { counters in
            counters.count == 3
                && counters[0].count == 9
                && counters[1].count == 5
                && counters[2].count == 7
        })
    }
}

let lockReducer: Reducer<LockState, LockAction, LockEnvironment> =
    counterReducer.forEach(
        state: \.counters,
        action: /LockAction.counter(id:action:),
        environment: { _ in CounterEnviroment.defaultEnv() }
    ).combined(with: Reducer { state, action, env in
        switch action {
        case let .setSheet(isPresented):
            state.isPresent = isPresented
            return .none

        case let .counter(id: id, action: .counterResponse(.success(value))):
            if env.tryToUnlock(state.counters) {
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
