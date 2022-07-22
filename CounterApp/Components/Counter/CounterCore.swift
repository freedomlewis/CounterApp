//
//  CounterCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/12.
//

import ComposableArchitecture

struct CounterState: Equatable, Identifiable {
    var id: UUID = .init()
    var count: Int = 0
    var min: Int = 0
    var max: Int = 9
}

enum CounterAction: Equatable {
    case onIncBtnTapped
    case onDecBtnTapped
    case incrementComplete(Result<Int, CounterClient.IncrementError>)
    case decrementComplete(Result<Int, CounterClient.DecrementError>)
}

struct CounterEnviroment {
    var queue: AnySchedulerOf<DispatchQueue>
    var increment: CounterClient.Increment
    var decrement: CounterClient.Decrement
}

let counterReducer = Reducer<CounterState, CounterAction, CounterEnviroment> { state, action, env in
    switch action {
    case .onIncBtnTapped:
        return env.increment(state.count, state.max)
            .receive(on: env.queue)
            .catchToEffect(CounterAction.incrementComplete)

    case .onDecBtnTapped:
        return env.decrement(state.count, state.min)
            .receive(on: env.queue)
            .catchToEffect(CounterAction.decrementComplete)

    case let .incrementComplete(.success(result)),
         let .decrementComplete(.success(result)):
        state.count = result
        return .none
        
    case .incrementComplete(.failure(_)),
         .decrementComplete(.failure(_)):
        return .none
    }
}
