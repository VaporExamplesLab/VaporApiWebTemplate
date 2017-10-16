import XCTest
import Foundation
import Testing
import HTTP
@testable import Vapor
@testable import App

/// This file shows an example of testing 
/// routes through the Droplet.

class RouteTests: TestCase {
    let drop = try! Droplet.testable()
    
    func testHelloApi() throws {
        try drop
            .testResponse(to: .get, at: "hello_api")
            .assertStatus(is: .ok)
            .assertJSON("hello", equals: "world")
    }
    
    func testInfoApi() throws {
        try drop
            .testResponse(to: .get, at: "info_api")
            .assertStatus(is: .ok)
            .assertBody(contains: "0.0.0.0")
    }
    
    func testWelcomeWeb() throws {
        try drop
            .testResponse(to: .get, at: "/")
            .assertStatus(is: .ok)
            .assertBody(contains: "It works")
    }
    
    func testHelloWeb() throws {
        try drop
            .testResponse(to: .get, at: "/hello_web/foo")
            .assertStatus(is: .ok)
            .assertBody(contains: "foo")
    }
    
    func testInfoWeb() throws {
        try drop
            .testResponse(to: .get, at: "info_web")
            .assertStatus(is: .ok)
            .assertBody(contains: "0.0.0.0")
    }
    
}

// MARK: Manifest

extension RouteTests {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testHelloApi", testHelloApi),
        ("testInfoApi", testInfoApi),
        ("testWelcomeWeb", testWelcomeWeb),
        ("testHelloWeb", testHelloWeb),
        ("testInfoWeb", testInfoWeb),
        ]
}
