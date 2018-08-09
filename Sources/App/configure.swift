import FluentSQLite
import Leaf
import Vapor

/// Called before application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register Service providers
    /// Vapor itself registers many services such as FileMiddleware & ErrorMiddleware.
    /// Add here services which are not otherwise registered by Vapor.
    try services.register(FluentSQLiteProvider())
    try services.register(LeafProvider())
    try services.register(ExampleServiceProvider()) // Example random message.
    services.register(ExampleMiddleware.self)       // Example middleware

    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware sequenced use order. 
    /// First listed will be first used in the request-response chain.
    var middlewares = MiddlewareConfig()    // Create _empty_ middleware config
    middlewares.use(ExampleMiddleware.self) // Example middleware adds an HTTP header value
    middlewares.use(FileMiddleware.self)    // Serve files from `Public/` directory
    middlewares.use(ErrorMiddleware.self)   // Catche and convert errors to HTTP responses
    services.register(middlewares)

    /// Configure SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Textpost.self, database: .sqlite)
    services.register(migrations)

    /// Configure rest of application here
    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands() // "revert", "migrate"
    services.register(commandConfig)
    
    /// Config application preferences
    config.prefer(ExampleQuoteService.self, for: ExampleService.self)
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    // config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
}
