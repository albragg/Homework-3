//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Jeff_Terry on 1/17/22.
//

import XCTest

class Tests_iOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMakeline() throws {
        
        let distance = 35.0
        let angle :CGFloat = 32.0
        let x :CGFloat = 24.0
        let y: CGFloat = 122.0
        
        let returnValue = makeline(distance: distance, angle: angle, x: x, y: y)
        
        XCTAssertEqual(returnValue[0].xPoint, 53.68168386334963, accuracy: 1.0E-7, "Was not equal to this resolution.")
        XCTAssertEqual(returnValue[0].yPoint, 140.54717345139602, accuracy: 1.0E-7, "Was not equal to this resolution.")

        
    }

    func testTurnAngle() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let angleChange :CGFloat = 13.0
        
        let angle :CGFloat = 90.0
        
        let newAngle = turn(angle: angle, angleChange: angleChange)
        
        XCTAssertEqual(newAngle, 103.0, accuracy: 1.0E-7, "Was not equal to this resolution.")
    
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
