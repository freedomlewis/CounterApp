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
            RootView(viewStore: viewStore)
        }
    }
}

struct RootView: View {
    let viewStore: ViewStore<AppState, AppAction>
    var body: some View {
        VStack {
            Text("\(viewStore.count)").font(Font.title2)
            HStack {
                Button("Inc") {
                    viewStore.send(.onIncBtnTapped)
                }.padding()
                
                Button("Dec"){
                    viewStore.send(.onDecBtnTapped)
                }.padding()
                    
            }
            .font(Font.title)
            .foregroundColor(Color.blue)
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
