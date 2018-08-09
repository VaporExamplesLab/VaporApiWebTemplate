//
//  _Testable+Models.swift
//  AppTests
//
//  Created by marc on 2018.08.08.
//

@testable import App
import FluentSQLite

/// Use _Testable+Models.swift to extend `Codable` or `Model` objects 
/// with `create(…)` to allow a unit test to add a database entry directly.

/// Models/Textpost
extension Textpost {
    static func createTestable(content: String, on connection: SQLiteConnection) throws -> Textpost {
        let textpost = Textpost(content: content)
        return try textpost.create(on: connection).wait()
    }
}


