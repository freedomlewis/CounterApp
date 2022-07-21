//
//  LockView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/12.
//

import ComposableArchitecture
import SwiftUI

struct LockView: View {
    let store: Store<LockState, LockAction>
    
    var body: some View {
        VStack {
            ForEachStore(
                self.store.scope(
                    state: \.counters,
                    action: LockAction.counter(id:action:)
                )
            ) { counterStore in
                CounterView(store: counterStore)
            }
        }
        .alert(
            self.store.scope(state: \.unlockAlert),
            dismiss: .alertDismissed
        )
    }
}

struct LockView_Previews: PreviewProvider {
    static var previews: some View {
        LockView(store: Store(
            initialState: .init(code: [9, 5, 7]),
            reducer: lockReducer,
            environment: LockEnvironment(counter: CounterEnviroment(
                queue: DispatchQueue.main.eraseToAnyScheduler(),
                increment: { value, _ in
                    Effect(value: value + 1)
                }, decrement: { value, _ -> Effect<Int, ServiceError> in
                    Effect(value: value - 1)
                }
            ))
        ))
    }
}
