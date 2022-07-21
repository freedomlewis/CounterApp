//
//  RandomGenerator.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import Foundation
import ComposableArchitecture

struct RandomGenerator {
    struct Interface {
        var generateFirstName: GenerateFirstName
    }
    
    typealias GenerateFirstName = () -> Effect<String, Never>
}
