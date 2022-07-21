//
//  AppCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/12.
//

import ComposableArchitecture
import Foundation

struct AppState: Equatable {
    var root: RootState = .init()
}

enum AppAction: Equatable {
    case root(RootAction)
}

let appReducer = Reducer<AppState, AppAction, AppEnviroment>.combine(
    rootReducer.pullback(
        state: \.root,
        action: /AppAction.root,
        environment: \.root
    )
).debug()

struct AppEnviroment {
}

extension AppEnviroment {
    var root: RootEnviroment {
        .init()
    }
}
