@testable import App
import FluentSQLite
import Vapor
import XCTest

/// This file shows an example of testing an
/// individual controller without initializing
/// a Droplet.

class TextpostControllerTests: XCTestCase {
    /// Vapor Test Application
    var app: Application!
    var connection: SQLiteConnection!
    
    override func setUp() {
        try! Application.resetTestable()
        app = try! Application.makeTestable()
        connection = try! app.newConnection(to: .sqlite).wait()
    }
    
    override func tearDown() {
        connection.close()
    }
    
    func testTextpost() {
        let text01 = "First post! :-)"
        // CREATE Textpost directly in database
        guard let textpost01 = try? Textpost.createTestable(content: text01, on: connection)
            else {
                XCTFail("TextpostControllerTests testTextpost() failed to create database entry text01.")
                return
        }
        
        // READ ALL GET /api/textposts
        let textpostsUri = "/api/textposts"
        var result = try! app.sendTestRequest(to: textpostsUri, decodeTo: [Textpost].self )
        XCTAssertEqual(result[0].content, text01)
        XCTAssertEqual(result.count, 1)

        let text02 = "Hickory, dickory, dock."
        guard let textpost02 = try? Textpost.createTestable(content: text02, on: connection)
            else {
                XCTFail("TextpostControllerTests testTextpost() failed to create database entry text02.")
                return
        }
        
        result = try! app.sendTestRequest(to: textpostsUri, decodeTo: [Textpost].self )
        XCTAssertEqual(result.count, 2)
        print(result)
    }
    
    // :NYI: TextpostApiController methods which are yet unit tested.
    // POST CREATE ONE
    // GET READ ONE
    // PUT UPDATE or CREATE
    // PATCH "PARTIAL" UPDATE
    // DELETE ONE
    // DELETE ALL

}

// MARK: - Manifest

extension TextpostControllerTests {
    /// `allTests` is required for XCTest to function properly on Linux.
    /// See ./Tests/LinuxMain.swift for examples.
    static let allTests = [
        ("testTextpost", testTextpost),
        ]
}
