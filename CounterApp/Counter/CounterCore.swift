//
//  CounterCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/12.
//

import ComposableArchitecture
import Foundation

struct CounterState: Equatable {
    var count: Int = 0
    var alert: AlertState<CounterAction>?
}

enum CounterAction: Equatable {
    case onIncBtnTapped
    case onDecBtnTapped
    case counterResponse(Result<Int, ServiceError>)
    case alertDismissed
}

struct ServiceError: Error, Equatable {
    var msg: String = "service error"
}

struct CounterEnviroment {
    var queue: AnySchedulerOf<DispatchQueue>

    // Takes a value and increments it by 1; Fails if result is greater than max.
    var increment: (Int, Int) -> Effect<Int, ServiceError>

    // Takes a value and decrements it by 1; Fails if result is lower than min.
    var decrement: (Int, Int) -> Effect<Int, ServiceError>

    static let MAX_VALUE = 5
    static let MIN_VALUE = -5
}

let counterReducer = Reducer<CounterState, CounterAction, CounterEnviroment> { state, action, env in
    switch action {
    case .onIncBtnTapped:
        return env.increment(state.count, CounterEnviroment.MAX_VALUE)
            .receive(on: env.queue)
            .catchToEffect(CounterAction.counterResponse)

    case .onDecBtnTapped:
        return env.decrement(state.count, CounterEnviroment.MIN_VALUE)
            .receive(on: env.queue)
            .catchToEffect(CounterAction.counterResponse)

    case let .counterResponse(.success(result)):
        state.count = result
        return .none

    case let .counterResponse(.failure(error)):
        state.alert = .init(title: .init(error.msg))
        return .none

    case .alertDismissed:
        state.alert = nil
        return .none
    }
}
