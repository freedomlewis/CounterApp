//
//  AppView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/7.
//

import ComposableArchitecture
import StoreKit
import SwiftUI

struct AppView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
            NavigationView {
                RootView(store: store.scope(state: \.root, action: AppAction.root))
            }
            .navigationViewStyle(.stack)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: Store(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnviroment()
        ))
    }
}
