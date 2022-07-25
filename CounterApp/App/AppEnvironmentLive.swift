//
//  AppEnvironmentLive.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import Foundation

extension AppEnvironment {
    init() {
        self.counterClient = .live
        self.randomClient = .live
    }
}
