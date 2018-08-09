import FluentSQLite
import Vapor

public struct Textpost: Codable {
    public var id: UUID? // database `id`. not initially present in database.
    public var content: String
    
    init(content: String) {
        self.content = content
    }
}

// Database model for fetching and saving data via Fluent.
extension Textpost: SQLiteUUIDModel {}

// Content convertable to/from HTTP message.
extension Textpost: Content {}

// Dynamic HTTP routing parameter: `id`
extension Textpost: Parameter {}

// Database migration
extension Textpost: Migration {
    /// Creating a new table or alters an existing table.
    public static func prepare(on connection: SQLiteConnection) -> Future<Void> {
        return Database.create(Textpost.self, on: connection) { 
            (builder: SchemaCreator<Textpost>) in
            try addProperties(to: builder)
            // builder.unique(on: \.somefield) // add unique contraint. also creates index. 
        }
    }
    
    /// Deletes database model schema.
    /// Used when app is activated with `--revert` option.
    public static func revert(on connection: SQLiteConnection) -> Future<Void> {
        return Database.delete(Textpost.self, on: connection)
    }
}
