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

struct AppEnviroment {}

let appReducer: Reducer<AppState, AppAction, AppEnviroment> = .combine(
    counterReducer.pullback(
        state: \AppState.counter,
        action: /AppAction.counter,
        environment: { _ in CounterEnviroment() }
    )
)

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
                    )))
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
