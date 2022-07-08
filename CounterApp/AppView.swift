//
//  AppView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/7.
//

import ComposableArchitecture
import StoreKit
import SwiftUI

struct AppState: Equatable {
    var counter: CounterState
}

enum AppAction: Equatable {
    case counter(CounterAction)
}

struct AppEnviroment {
    let counterEnv = CounterEnviroment(
        queue: DispatchQueue.main.eraseToAnyScheduler(),
        increment: { value, max in
            if value < max {
                return Effect(value: value + 1)
            } else {
                return Effect(error: ServiceError(msg: "Inc failed: greater than max \(max)"))
            }
        }, decrement: { value, min -> Effect<Int, ServiceError> in
            if value > min {
                return Effect(value: value - 1)
            } else {
                return Effect(error: ServiceError(msg: "Dec falied: lower than min \(min)"))
            }
        }
    )
}

let appReducer: Reducer<AppState, AppAction, AppEnviroment> = .combine(
    counterReducer.pullback(
        state: \AppState.counter,
        action: /AppAction.counter,
        environment: { env in env.counterEnv }
    )
).debug()

struct AppView: View {
    let store = Store(
        initialState: AppState(counter: CounterState()),
        reducer: appReducer,
        environment: AppEnviroment()
    )

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    Text("\(viewStore.counter.count)").font(Font.title2).padding()
                    NavigationLink("Goto edit page", destination: CounterView(store: self.store.scope(
                        state: \.counter,
                        action: AppAction.counter
                    ))).font(Font.title2)
                }
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
