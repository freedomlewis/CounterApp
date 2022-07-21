//
//  CounterClient.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import ComposableArchitecture

struct CounterClient {
    
    struct Interface {
        var increment: Increment
        var decrement: Decrement
    }
    
    typealias Increment = (Int, Int) -> Effect<Int, IncrementError>
    typealias Decrement = (Int, Int) -> Effect<Int, DecrementError>
    
    struct IncrementError: Error, Equatable{
        var msg: String
    }

    struct DecrementError: Error, Equatable {
        var msg: String
    }
}
