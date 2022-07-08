//
//  ContentView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/6.
//

import ComposableArchitecture
import SwiftUI

struct CounterState: Equatable {
    var count: Int = 0
    var alertMsg: String?
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

    static let MAX_VALUE = 10
    static let MIN_VALUE = -10
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
        state.alertMsg = error.msg
        return .none
    case .alertDismissed:
        return .none
    }
}

struct CounterAlert: Identifiable {
    var title: String
    var id: String { self.title }
}

struct CounterView: View {
    let store: Store<CounterState, CounterAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text("\(viewStore.count)").font(Font.title2)
                HStack {
                    Button("Inc") {
                        viewStore.send(.onIncBtnTapped)
                    }.padding()

                    Button("Dec") {
                        viewStore.send(.onDecBtnTapped)
                    }.padding()
                }
                .font(Font.title)
                .foregroundColor(Color.blue)
            }.alert(
                item: viewStore.binding(
                    get: { $0.alertMsg.map(CounterAlert.init(title:)) },
                    send: .alertDismissed
                ),
                content: { Alert(title: Text($0.title).font(Font.title3)) }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(store: Store(
            initialState: CounterState(),
            reducer: counterReducer,
            environment: CounterEnviroment(
                queue: DispatchQueue.main.eraseToAnyScheduler(),
                increment: { _, _ in Effect(value: 1) },
                decrement: { _, _ in Effect(error: ServiceError(msg: "Dec failed: lower than min -10")) }
            )
        ))
    }
}
