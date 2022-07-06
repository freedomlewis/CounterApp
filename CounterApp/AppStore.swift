//
//  AppStore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/6.
//

import ComposableArchitecture
import Foundation

let appStore = Store(
    initialState: AppState(),
    reducer: appReducer,
    environment: AppEnviroment()
)

struct AppEnviroment {}
