//
//  ExampleMiddleware.swift
//  App
//
//  Created by marc on 2018.08.05.
//

import Vapor

struct ExampleMiddleware: Middleware {
    
    // reference type for mutating inside closure
    internal class _infoWrapper {
        let uuid = UUID()
        var counter = 0
    }
    
    let info = _infoWrapper()
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        // if needed, process inbound `request` here.
        Swift.print("ExampleMiddleware inbound request: \(request.description)")
        
        // pass next inbound `request` to next middleware in processing chain
        //let response: Response = try next.respond(to: request)
        
        return try next.respond(to: request).map { 
            (response: Response) -> Response in
            // if needed, process outbound `response` here
            response.http.headers.replaceOrAdd(name: "Example-Middleware-UUID", value: self.info.uuid.rfc4122String)
            response.http.headers.replaceOrAdd(name: "Example-Middleware-Count", value: "\(self.info.counter)")
            self.info.counter += 1
            Swift.print("ExampleMiddleware outbound response: \(response.description)")
            
            // return `response` to chain back up any remaining middleware to client
            return response
        }
    }
    
}

extension ExampleMiddleware: ServiceType {
    public static func makeService(for worker: Container) throws -> ExampleMiddleware {
        return ExampleMiddleware()
    }
}
