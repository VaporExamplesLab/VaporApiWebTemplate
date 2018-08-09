@testable import App
import Vapor
import XCTest

class RoutesTests: XCTestCase {
    /// Vapor Test Application
    var app: Application!

    override func setUp() {
        try! Application.resetTestable()
        app = try! Application.makeTestable()
    }
    
    override func tearDown() {
        // nothing to  do.
    }
    
    func testRouteHello() throws {
        let helloUri = "/hello"
        let response = try app.sendTestRequest(to: helloUri, method: HTTPMethod.GET)
        //print("••• /hello\n\(response)\n•••")

        // Check response
        XCTAssertEqual(response.http.status, HTTPStatus.ok)
        if let data = response.http.body.data,
            let responseBodyStr = String(data: data, encoding: String.Encoding.utf8) {
            XCTAssert(responseBodyStr.contains("Hello, world!")) 
        }    
        else {
            XCTFail("RoutesTests testRouteHello() has nil body data.")
        }
    }
    
    func testRouteHelloJson() throws {
        let helloJsonUri = "/hellojson"
        let response = try app.sendTestRequest(to: helloJsonUri, method: HTTPMethod.GET)
        //print("••• /hellojson\n\(response)\n•••")

        // Check response
        XCTAssertEqual(response.http.status, HTTPStatus.ok)
        if let jsonData = response.http.body.data {
            if let json = try JSONSerialization.jsonObject(with: jsonData) as? [String:String] {
                XCTAssert(json["hello"]! == "world")
            }
            else {
                XCTFail("RoutesTests testRouteHelloJson() JSON conversion failed.")
            }
        }    
        else {
            XCTFail("RoutesTests testRouteHelloJson() has nil body data.")
        }
    }
    
    func testRouteInfo() throws {
        let infoUri = "/info"
        let response = try app.sendTestRequest(to: infoUri, method: HTTPMethod.GET)
        print("••• /info\n\(response)\n•••")
        
        // Check response
        XCTAssertEqual(response.http.status, HTTPStatus.ok)
        if let data = response.http.body.data,
            let responseBodyStr = String(data: data, encoding: String.Encoding.utf8) {
            XCTAssert(responseBodyStr.contains("GET /info"))
            XCTAssert(responseBodyStr.contains("HTTP/1.1"))
            XCTAssert(responseBodyStr.contains("content-length"))
            XCTAssert(responseBodyStr.contains("<no body>"))
        }    
        else {
            XCTFail("RoutesTests testRouteInfo() has nil body data.")
        }
    }
    
}

// MARK: - Manifest

extension RoutesTests {
    /// `allTests` is required for XCTest to function properly on Linux.
    /// See ./Tests/LinuxMain.swift for examples.
    static let allTests = [
        ("testRouteHello", testRouteHello),
        ("testRouteHelloJson", testRouteHelloJson),
        ("testRouteInfo", testRouteInfo),
        ]
}
