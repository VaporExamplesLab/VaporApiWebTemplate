//
//  ExampleServiceProvider.swift
//  App
//
//  Created by marc on 2018.08.03.
//

import Foundation
import Vapor

public final class ExampleServiceProvider: Provider {
    /// Create a new `ExampleServiceProvider`
    public init() {}
    
    /// Register all services to be provided to the `Container` here.
    public func register(_ services: inout Services) throws {
        services.register(ExampleQuoteService.self)
        services.register(ExampleFortuneService.self)
    }
    
    /// Called before the container has fully initialized.
    //func willBoot(_ container: Container) throws -> Future<Void> {  }
    
    /// Called after the container has fully initialized and after `willBoot(_:)`.
    public func didBoot(_ container: Container) throws -> Future<Void> {
        let exampleService = try container.make(ExampleService.self)
        let message = exampleService.getRandomMessage()
        print("ExampleService: \(message)")
        
        return .done(on: container)
    }
}
