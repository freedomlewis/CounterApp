//
//  CounterAppTests.swift
//  CounterAppTests
//
//  Created by Wenjuan Li on 2022/7/6.
//

import ComposableArchitecture
import XCTest
@testable import CounterApp

class AppReducerTests: XCTestCase {

    let state = AppState()

    func testCountUpAndDown() throws {
        let store = TestStore(initialState: state, reducer: appReducer, environment: AppEnviroment())
        store.send(.onIncBtnTapped) {
            $0.count = 1
        }
        store.send(.onDecBtnTapped){
            $0.count = 0
        }
    }

}
