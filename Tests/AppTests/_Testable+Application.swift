//
//  _Testable_Application.swift
//  AppTests
//
//  Created by marc on 2018.08.07.
//

@testable import App
import Vapor
import FluentSQLite

extension Application {
    static func makeTestable(envArgs: [String]? = nil) throws -> Application {
        var config = Config.default()
        var services = Services.default()
        var env = Environment.testing
        
        if let environmentArgs = envArgs {
            env.arguments = environmentArgs
        }
        
        try App.configure(&config, &env, &services)
        let app = try Application(config: config, environment: env, services: services)
        
        try App.boot(app)
        return app
    }
    
    static func resetTestable() throws {
        let revertEnvironment = ["vapor", "revert", "--all", "-y"]
        try Application.makeTestable(envArgs: revertEnvironment).asyncRun().wait()
        let migrateEnvironment = ["vapor", "migrate", "-y"]
        try Application.makeTestable(envArgs: migrateEnvironment).asyncRun().wait()
    }
    
    /// Send request without body.
    func sendTestRequest(
        to path: String, 
        method: HTTPMethod, 
        headers: HTTPHeaders = .init()
        ) throws -> Response {
        let nilBodyContent: BodyContent? = nil
        return try self.sendTestRequest(to: path, method: method, headers: headers, body: nilBodyContent)
    }
    
    /// Send request with body<T> `Encodable`.
    func sendTestRequest<T>(
        to path: String, 
        method: HTTPMethod, 
        headers: HTTPHeaders = .init(),  
        body: T?
        ) throws -> Response where T: Content {
        let responder = try self.make(Responder.self)
        let httpRequest = HTTPRequest(method: method, url: URL(string: path)!, headers: headers)
        let request = Request(http: httpRequest, using: self)
        if let body = body {
            try request.content.encode(body)            
        }
        return try responder.respond(to: request).wait()
    }
    
    /// Send request, without body, which returns Decodable<U>.
    func sendTestRequest<U>(
        to path: String, 
        method: HTTPMethod = .GET, 
        headers: HTTPHeaders = .init(), 
        decodeTo type: U.Type
        ) throws -> U where U: Decodable {
        
        let nilBodyContent: BodyContent? = nil
        return try self.sendTestRequest(to: path, method: method, headers: headers, body: nilBodyContent, decodeTo: type)
    }
    
    /// Send request with body<T> which returns Decodable<U>.
    func sendTestRequest<T, U>(
        to path: String, 
        method: HTTPMethod = .GET, 
        headers: HTTPHeaders = .init(), 
        body: T? = nil, 
        decodeTo type: U.Type
        ) throws -> U where T: Content, U: Decodable {
        
        let response = try self.sendTestRequest(to: path, method: method, headers: headers, body: body)
        return try response.content.decode(type).wait()
    }
    
    struct BodyContent: Content {}
}
