//
//  PanicMechanicCycleTests.swift
//  PanicMechanicTests
//
//  Created by Synbrix Software on 1/27/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import XCTest


@testable import PanicMechanic

class PanicMechanicCycleTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testScaleHR() {
        // Given
        let hr = 100
        let cycle = PanicMechanicCycle(hr: hr, hrTs: nil, rating: 10, ratingTs: nil, question: [:], endTs: Date())
        
        // When
        let scaler = 5
        let scaledHR = cycle.scaleHR(scaler: scaler)
        
        //Then
        XCTAssertEqual(scaledHR, hr * scaler)
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
