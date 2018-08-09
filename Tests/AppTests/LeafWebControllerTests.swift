@testable import App
import XCTest
import Vapor

class LeafWebControllerTests: XCTestCase {
    /// Vapor Test Application
    var app: Application!
    
    override func setUp() {
        try! Application.resetTestable()
        app = try! Application.makeTestable()
    }
    
    override func tearDown() {
        // nothing to  do.
    }
    
    func testLeafHelloName() throws {
        /// GET /leaf/hello/:string
        let name = "Ægir" // some name which will have percent encoding.
        guard let nameEncoded = name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) 
            else {
                XCTFail("LeafWebControllerTests testLeafHelloName() percent encoding failed.")
                return
        }
        let leafHelloNameUri = "/leaf/hello/\(nameEncoded)"
        //print("••• leafHelloNameUri = \(leafHelloNameUri)")
        
        let response = try app.sendTestRequest(to: leafHelloNameUri, method: HTTPMethod.GET)
        
        //print("••• /leaf/hello/:string\n\(response)\n•••")
        
        // Check response
        XCTAssertEqual(response.http.status, HTTPStatus.ok)
        if let data = response.http.body.data,
            let responseBodyStr = String(data: data, encoding: String.Encoding.utf8) {
            XCTAssert( responseBodyStr.contains(name) )
        }    
        else {
            XCTFail("LeafWebControllerTests testLeafHelloName() has nil body data.")
        }
    }

}

// MARK: - Manifest

extension LeafWebControllerTests {
    /// `allTests` is required for XCTest to function properly on Linux.
    /// See ./Tests/LinuxMain.swift for examples.
    static let allTests = [
        ("testLeafHelloName", testLeafHelloName),
        ]
}
