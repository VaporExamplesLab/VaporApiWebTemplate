// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VaporApiWebTemplate",
    dependencies: [
        // 3.1.0   2018.09.19
        .package(url: "https://github.com/vapor/vapor.git", from: "3.1.0"),
        
        // 3.0.0   2018.07.17
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),
        
        // 3.0.2   2018.10.30
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.2"),
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentSQLite", "Vapor", "Leaf"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ],
    swiftLanguageVersions: [.v4_2]
)

