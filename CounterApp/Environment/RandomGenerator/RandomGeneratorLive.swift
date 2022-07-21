//
//  RandomGeneratorLive.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import ComposableArchitecture
import Foundation

extension RandomGenerator.Interface {
    static var live: Self {
        .init(
            generateFirstName: {
                Effect.timer(
                    id: RandomGeneratorTimerId.self,
                    every: 5,
                    on: DispatchQueue.main.eraseToAnyScheduler()
                )
                .map { _ in
                    Randoms.randomFakeFirstName()
                }
                .eraseToEffect()
            }
        )
    }
}

enum RandomGeneratorTimerId {}
