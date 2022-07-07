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
            DisplayAndNavigateView(viewStore: viewStore)
        }
    }
}

struct DisplayAndNavigateView: View {
    let viewStore: ViewStore<AppState, AppAction>

    var body: some View {
        NavigationView {
            VStack {
                Text("\(viewStore.count)").font(Font.title2).padding()
                NavigationLink("Goto edit page", destination: EditorView(viewStore: viewStore))
            }
        }
    }
}

struct EditorView: View {
    let viewStore: ViewStore<AppState, AppAction>
    var body: some View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(store: Store(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnviroment()
        ))
    }
}
