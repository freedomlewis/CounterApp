//
//  CounterClientLive.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import ComposableArchitecture

extension CounterClient.Interface {
    static var live: CounterClient.Interface {
        .init(
            increment: { value, max in
                if value < max {
                    return Effect(value: value + 1)
                } else {
                    return Effect(error: CounterClient.IncrementError(msg: "Inc failed: greater than max \(max)"))
                }
            },
            decrement: { value, min in
                if value > min {
                    return Effect(value: value - 1)
                } else {
                    return Effect(error: CounterClient.DecrementError(msg: "Dec falied: lower than min \(min)"))
                }
            }
        )
    }
}
