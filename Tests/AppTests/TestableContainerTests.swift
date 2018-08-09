//
//  TestableContainerTests.swift
//  AppTests
//
//  Created by marc on 2018.08.09.
//

@testable import App
import XCTest
import Vapor

/// 
class TestableContainerTests: XCTestCase {
    /// Vapor Test Application
    var container: TestableContainer!
    
    override func setUp() {
        container = try! TestableContainer()
    }
    
    override func tearDown() {
        // nothing to  do.
}

    func testTestableContainer() {
        let request = Request(using: container) 
        let leafController = LeafWebController()
        let view: View = try! leafController.bootstrapExampleHandler(request).wait()
        let viewDataStr = String(data: view.data, encoding: .utf8)!
        //print(viewDataStr)
        XCTAssert( viewDataStr.contains("<!DOCTYPE html") )
    }
    
}

// MARK: - Manifest

extension TestableContainerTests {
    /// `allTests` is required for XCTest to function properly on Linux.
    /// See ./Tests/LinuxMain.swift for examples.
    static let allTests = [
        ("testTestableContainer", testTestableContainer),
        ]
}
