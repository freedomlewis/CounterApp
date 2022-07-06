//
//  CounterReducer.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/6.
//

import ComposableArchitecture
import Foundation

enum AppAction: Equatable {
    case onIncBtnTapped
    case onDecBtnTapped
}

struct AppEnviroment {}

let appReducer = Reducer<AppState, AppAction, AppEnviroment> { state, action, _ in
    switch action {
    case .onIncBtnTapped:
        state.count += 1

    case .onDecBtnTapped:
        state.count -= 1
    }

    return .none
}
.debug()
.signpost()
