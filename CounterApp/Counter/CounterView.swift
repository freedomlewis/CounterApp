//
//  ContentView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/6.
//

import ComposableArchitecture
import SwiftUI

struct CounterView: View {
    let store: Store<CounterState, CounterAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Button("Inc") {
                    viewStore.send(.onIncBtnTapped)
                }

                Text("\(viewStore.count)")
                    .foregroundColor(Color.black)
                    .padding()

                Button("Dec") {
                    viewStore.send(.onDecBtnTapped)
                }
            }
            .font(Font.title)
            .alert(
                self.store.scope(state: \.alert),
                dismiss: .alertDismissed
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
