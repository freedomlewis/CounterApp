//
//  CounterAppApp.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/6.
//

import ComposableArchitecture
import SwiftUI

@main
struct CounterApp: App {
    let appStore = Store(
        initialState: AppState(
            counter: CounterState(),
            lock: LockState(
                counters: [
                    CounterState(count: 0),
                    CounterState(count: 5),
                    CounterState(count: 9)
                ]
            ),
            users: UsersState()
        ),
        reducer: appReducer,
        environment: AppEnviroment()
    )
    
    var body: some Scene {
        WindowGroup {
            AppView(store: appStore)
        }
    }
}
