//
//  CounterDetailView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/22.
//

import ComposableArchitecture
import SwiftUI

struct CounterDetailView: View {
    let store: Store<CounterDetailState, CounterDetailAction>
    
    var body: some View {
        WithViewStore(store) { _ in
            HStack {
                CounterView(
                    store: self.store.scope(
                        state: \.counter,
                        action: CounterDetailAction.counter
                    )
                )
            }
            .font(Font.title)
            .alert(
                self.store.scope(state: \.alert),
                dismiss: .alertDismissed
            )
        }
    }
}

struct CounterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CounterDetailView(store: Store(
            initialState: CounterDetailState(
                counter: CounterState()),
            reducer: counterDetailReducer,
            environment: CounterDetailEnviroment(
                counter: CounterEnviroment(
                    queue: DispatchQueue.main.eraseToAnyScheduler(),
                    increment: { _, _ in Effect(value: 1) },
                    decrement: { _, _ in Effect(value: 1) }
                )
            )
        )
        )
    }
}
