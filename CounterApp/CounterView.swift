//
//  ContentView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/6.
//

import ComposableArchitecture
import SwiftUI

struct CounterView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text("\(viewStore.count)").font(Font.title2)
                HStack {
                    Text("Inc")
                        .padding()
                        .onTapGesture {
                            viewStore.send(.onIncBtnTapped)
                        }
                    Text("Dec")
                        .padding()
                        .onTapGesture {
                            viewStore.send(.onDecBtnTapped)
                        }
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
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnviroment()
        ))
    }
}
