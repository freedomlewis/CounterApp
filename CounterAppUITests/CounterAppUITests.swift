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
        
        let navigationBtn = app.buttons["Goto edit page"]
        navigationBtn.tap()
                
        let incBtn = app.buttons["Inc"]
        let decBtn = app.buttons["Dec"]
        
        XCTAssert(incBtn.waitForExistence(timeout: 0.5))
        XCTAssert(decBtn.waitForExistence(timeout: 0.5))
        
        incBtn.tap()
        XCTAssert(app.staticTexts["1"].waitForExistence(timeout: 0.5))
        
        decBtn.tap()
        XCTAssert(app.staticTexts["0"].waitForExistence(timeout: 0.5))
    }
}
