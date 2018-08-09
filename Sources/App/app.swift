import Vapor

/// `app` creates an `Application` instance. 
/// `app` is called from Sources/Run/main.swift via the Swift Package `Run` target.
public func app(_ env: Environment) throws -> Application {
    var config = Config.default()
    var env = env
    var services = Services.default()
    try configure(&config, &env, &services)
    let app = try Application(config: config, environment: env, services: services)
    try boot(app)
    return app
}
