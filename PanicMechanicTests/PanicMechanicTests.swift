//
//  PanicMechanicTests.swift
//  PanicMechanicTests
//
//  Created by Synbrix Software on 1/27/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import XCTest

@testable import PanicMechanic

class PanicMechanicTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let server_url = Environment().configuration(PlistKey.ServerURL)
        print(server_url)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
