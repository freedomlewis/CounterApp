//
//  CounterAppUITests.swift
//  CounterAppUITests
//
//  Created by Wenjuan Li on 2022/7/6.
//

import XCTest

class CounterAppUITests: XCTestCase {

    func testCountDownAndUp() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let incBtn = app.staticTexts["Inc"]
        let decBtn = app.staticTexts["Dec"]
        
        XCTAssert(incBtn.exists)
        XCTAssert(decBtn.exists)
        
        incBtn.tap()
        
        let countText = app.staticTexts["1"]
        XCTAssert(countText.waitForExistence(timeout: 0.5))
    }
}
