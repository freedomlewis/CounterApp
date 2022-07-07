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
}

enum CounterAction: Equatable {
    case onIncBtnTapped
    case onDecBtnTapped
}

struct CounterEnviroment {}

let counterReducer = Reducer<CounterState, CounterAction, CounterEnviroment> { state, action, _ in
    switch action {
    case .onIncBtnTapped:
        state.count += 1

    case .onDecBtnTapped:
        state.count -= 1
    }

    return .none
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
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(store: Store(
            initialState: CounterState(),
            reducer: counterReducer,
            environment: CounterEnviroment()
        ))
    }
}
