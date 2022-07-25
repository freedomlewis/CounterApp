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
    let appStore = Store(initialState: AppState(), reducer: appReducer, environment: AppEnvironment())
    
    var body: some Scene {
        WindowGroup {
            AppView(store: appStore)
        }
    }
}
