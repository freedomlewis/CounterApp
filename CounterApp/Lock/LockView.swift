//
//  LockView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/12.
//

import ComposableArchitecture
import SwiftUI

struct LockState: Equatable {
    var counters: IdentifiedArrayOf<CounterState> = []
}

enum LockAction: Equatable {
    case counter(id: CounterState.ID, action: CounterAction)
}

struct LockEnvironment {}

let lockReducer: Reducer<LockState, LockAction, LockEnvironment> = counterReducer.forEach(
    state: \.counters,
    action: /LockAction.counter(id:action:),
    environment: { _ in CounterEnviroment.defaultEnv() }
)

struct LockView: View {
    let store: Store<LockState, LockAction>

    var body: some View {
        VStack {
            ForEachStore(
                self.store.scope(state: \.counters, action: LockAction.counter(id:action:))
            ) { counterStore in
                CounterView(store: counterStore)
            }
        }
    }
}

struct LockView_Previews: PreviewProvider {
    static var previews: some View {
        LockView(store: Store(
            initialState: LockState(counters: [CounterState(), CounterState(), CounterState()]),
            reducer: lockReducer,
            environment: LockEnvironment()
        ))
    }
}
