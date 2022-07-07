//
//  AppReducerTests.swift
//  CounterAppTests
//
//  Created by Wenjuan Li on 2022/7/7.
//

import ComposableArchitecture
import XCTest
@testable import CounterApp

class AppReducerTests: XCTestCase {

    let state = AppState(counter: CounterState())

    func testCountUpAndDown() throws {
        let store = TestStore(initialState: state, reducer: appReducer, environment: AppEnviroment())
        store.send(.counter(.onIncBtnTapped)) {
            $0.counter.count = 1
        }
        store.send(.counter(.onDecBtnTapped)){
            $0.counter.count = 0
        }
    }

}
