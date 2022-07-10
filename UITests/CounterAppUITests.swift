//
//  CounterAppUITests.swift
//  CounterAppTests
//
//  Created by QinChao Xu on 2022/7/10.
//

import XCTest

class CounterAppUITests: XCTestCase {
    private let app: XCUIApplication = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLocalIncAndDec() throws {
        app.buttons["Edit"].tap()
        let incButton = app.buttons["+"]
        incButton.tap()
        XCTAssertTrue(app.staticTexts["1"].waitForExistence(timeout: 0.5))
        
        let decButton = app.buttons["-"]
        decButton.tap()
        XCTAssertTrue(app.staticTexts["0"].waitForExistence(timeout: 0.5))
    }
    
    func testEffectIncAndDec() throws {
        app.buttons["Edit"].tap()
        let incButton = app.buttons["Inc"]
        incButton.tap()
        XCTAssertTrue(app.staticTexts["1"].waitForExistence(timeout: 0.5))
        
        let decButton = app.buttons["Dec"]
        decButton.tap()
        XCTAssertTrue(app.staticTexts["0"].waitForExistence(timeout: 0.5))
    }
}
