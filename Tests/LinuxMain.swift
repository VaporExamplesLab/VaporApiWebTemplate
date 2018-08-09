#if os(Linux)

import XCTest
@testable import AppTests

XCTMain([
    // AppTests
    testCase(AppTests.allTests),
    testCase(HelloControllerTests.allTests),
    testCase(PostControllerTests.allTests),
    testCase(RouteTests.allTests)
])

#endif
