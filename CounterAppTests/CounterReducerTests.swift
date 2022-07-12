//
//  CounterAppTests.swift
//  CounterAppTests
//
//  Created by Wenjuan Li on 2022/7/6.
//

import ComposableArchitecture
import XCTest
@testable import CounterApp

class CounterReducerTests: XCTestCase {

    let state = CounterState()
    let queue = DispatchQueue.test

    func testCountUpAndDown() throws {
        let store = TestStore(
            initialState: state,
            reducer: counterReducer,
            environment: CounterEnviroment(
                queue: queue.eraseToAnyScheduler(),
                increment: {value, max in
                    if value >= 1 {
                        return Effect(error: ServiceError(msg: "Inc failed"))
                    }else {
                        return Effect(value: value + 1)
                    }
                },
                decrement: {value, min in Effect(value: value - 1)})
        )

        store.send(.onIncBtnTapped)
        queue.advance()
        store.receive(.counterResponse(.success(1))) {
            $0.count = 1
        }

        store.send(.onIncBtnTapped)
        queue.advance()
        store.receive(.counterResponse(.failure(ServiceError(msg: "Inc failed")))) {
            $0.count = 1
        }

        store.send(.onDecBtnTapped)
        queue.advance()
        store.receive(.counterResponse(.success(0))) {
            $0.count = 0
        }
    }

}
