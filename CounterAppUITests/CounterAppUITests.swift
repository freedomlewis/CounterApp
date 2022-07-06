//
//  CounterAppUITests.swift
//  CounterAppUITests
//
//  Created by Wenjuan Li on 2022/7/6.
//

import XCTest

class CounterAppUITests: XCTestCase {

    func testCountDownAndUp() throws {
        let app = XCUIApplication()
        app.launch()
        
        let incBtn = app.buttons["Inc"]
        let decBtn = app.buttons["Dec"]
        
        XCTAssert(incBtn.exists)
        XCTAssert(decBtn.exists)
        
        incBtn.tap()
        XCTAssert(app.staticTexts["1"].waitForExistence(timeout: 0.5))
        
        decBtn.tap()
        XCTAssert(app.staticTexts["0"].waitForExistence(timeout: 0.5))
    }
}
