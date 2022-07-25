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

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    rootReducer.pullback(
        state: \.root,
        action: /AppAction.root,
        environment: \.root
    )
).debug()

struct AppEnvironment {
    var counterClient: CounterClient.Interface
    var randomClient: RandomGenerator.Interface
}

extension AppEnvironment {
    var root: RootEnvironment {
        .init(
            counterEnv: .init(
                queue: DispatchQueue.main.eraseToAnyScheduler(),
                increment: counterClient.increment,
                decrement: counterClient.decrement
            ),
            firstNameGenerator: randomClient.generateFirstName,
            cancelNameGenrator: randomClient.cancelFirstNameGenerator
        )
    }
}
