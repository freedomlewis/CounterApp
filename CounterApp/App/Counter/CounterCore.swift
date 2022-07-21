//
//  CounterCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/12.
//

import ComposableArchitecture
import Foundation

struct CounterState: Equatable, Identifiable {
    var id: UUID = .init()
    var count: Int = 0
    var alert: AlertState<CounterAction>?
}

enum CounterAction: Equatable {
    case onIncBtnTapped
    case onDecBtnTapped
    case incrementComplete(Result<Int, CounterClient.IncrementError>)
    case decrementComplete(Result<Int, CounterClient.DecrementError>)
    case alertDismissed
}

struct CounterEnviroment {
    var queue: AnySchedulerOf<DispatchQueue>
    var increment: CounterClient.Increment
    var decrement: CounterClient.Decrement

    static let MAX_VALUE = 9
    static let MIN_VALUE = 0
}

let counterReducer = Reducer<CounterState, CounterAction, CounterEnviroment> { state, action, env in
    switch action {
    case .onIncBtnTapped:
        return env.increment(state.count, CounterEnviroment.MAX_VALUE)
            .receive(on: env.queue)
            .catchToEffect(CounterAction.incrementComplete)

    case .onDecBtnTapped:
        return env.decrement(state.count, CounterEnviroment.MIN_VALUE)
            .receive(on: env.queue)
            .catchToEffect(CounterAction.decrementComplete)

    case let .incrementComplete(.success(result)),
         let .decrementComplete(.success(result)):
        state.count = result
        return .none

    case let .incrementComplete(.failure(error)):
        state.alert = .init(title: .init(error.msg))
        return .none
    
    case let .decrementComplete(.failure(error)):
        state.alert = .init(title: .init(error.msg))
        return .none
        
    case .alertDismissed:
        state.alert = nil
        return .none
    }
}
