//
//  LockCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/12.
//

import ComposableArchitecture
import Foundation

struct LockState: Equatable {
    var code: [Int]
    var counters: IdentifiedArrayOf<CounterState> = []
    var unlockAlert: AlertState<LockAction>?
    
    init(code: [Int]) {
        self.code = code
        self.counters = .init(uniqueElements: (0..<code.count).map{_ in CounterState()}) 
    }
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
        case let .counter(id: id, action: .incrementComplete(.success(value))),
            let .counter(id: id, action: .decrementComplete(.success(value))):
            if state.counters.map(\.count) == state.code {
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
