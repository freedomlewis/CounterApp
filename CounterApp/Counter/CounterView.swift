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
            VStack {
                Text("\(viewStore.count)").font(Font.title2)
                HStack {
                    Button("Inc") { viewStore.send(.onIncBtnTapped) }.padding()
                    Button("Dec") { viewStore.send(.onDecBtnTapped) }.padding()
                }
                .font(Font.title)
                .foregroundColor(Color.blue)
            }.alert(
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
