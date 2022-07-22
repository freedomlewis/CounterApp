//
//  CounterDetailCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/22.
//

import ComposableArchitecture

struct CounterDetailState: Equatable {
    var counter: CounterState
    var alert: AlertState<CounterDetailAction>?
}

enum CounterDetailAction: Equatable {
    case counter(CounterAction)
    case alertDismissed
    case didSetValue(Int)
}

struct CounterDetailEnviroment {
    var counter: CounterEnviroment
}

let counterDetailReducer = Reducer<CounterDetailState, CounterDetailAction, CounterDetailEnviroment>.combine(
    counterReducer.pullback(state: \.counter, action: /CounterDetailAction.counter, environment: \.counter),
    Reducer { state, action, _ in
        switch action {
        case let .counter(.incrementComplete(.failure(error))):
            state.alert = .init(title: .init(error.msg))
            return .none
            
        case let .counter(.decrementComplete(.failure(error))):
            state.alert = .init(title: .init(error.msg))
            return .none
            
        case .alertDismissed:
            state.alert = nil
            return .none
            
        case let .counter(.incrementComplete(.success(value))),
            let .counter(.decrementComplete(.success(value))):
            return Effect(value: .didSetValue(value))
            
        default:
            return .none
        }
    }
)
