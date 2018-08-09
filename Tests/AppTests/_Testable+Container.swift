//
//  _Testable+Container.swift
//  AppTests
//
//  Created by marc on 2018.08.09.
//

import FluentSQLite
import Leaf
import Vapor

/// `TestableContainer` provides a `Container` to factilitate testing a `Controller` without booting the entire Vapor `Application`.
public final class TestableContainer: Container {
    public var config: Config
    public var environment: Environment
    public var services: Services
    public var serviceCache: ServiceCache
    
    /// `EventLoopGroup` which provides the `eventLoop` below. Must be closed in `deinit`.
    private var eventLoopGroup: EventLoopGroup
    
    /// EventLoop to use during unit test.
    public var eventLoop: EventLoop {
        return eventLoopGroup.next()
    }
    
    /// Synchronously creates and boots a new `ContainerTestable`.
    ///
    /// - parameters:
    ///     - config: Configuration preferences for this service container.
    ///     - environment: environment type (i.e., testing, production).
    ///     - services: available services.
    public convenience init(
        config: Config = Config.testable(), // .default()
        environment: Environment = Environment.testing,
        services: Services = Services.testable() // .default()
        ) throws {
        self.init(config, environment, services)
        // SEE: Application: Container "try boot().wait()"
        
    }
    
    // MARK: Internal
    
    /// Internal initializer. Creates an `Application` without booting providers.
    internal init(_ config: Config, _ environment: Environment, _ services: Services) {
        self.config = config
        self.environment = environment
        self.services = services
        self.serviceCache = .init()
        //self.extend = Extend()
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    }
    
    /// Internal method. Boots the container and its providers.
    internal func boot() -> Future<Void> {
        return Future.flatMap(on: self) {
            // will-boot all service providers
            return try self.providers.map { try $0.willBoot(self) }.flatten(on: self)
            }.flatMap {
                // did-boot all service providers
                return try self.providers.map { try $0.didBoot(self) }.flatten(on: self)
        }
    }
    
    /// Called when the app deinitializes.
    deinit {
        eventLoopGroup.shutdownGracefully {
            if let error = $0 {
                print("[Vapor] [TESTABLE] [ERROR] shutting down app event loop: \(error)")
            }
        }
    }
}

extension Config {
    /// SEE ALSO: static func `default`() -> Config
    public static func testable() -> Config {
        var config = Config()
        config.prefer(LeafRenderer.self, for: ViewRenderer.self)
        return config
    }
}

extension Services {
    /// SEE ALSO: "static func `default`() -> Services"
    public static func testable() -> Services {
        var services = Services()
        
        // server
        services.register(NIOServer.self)
        services.register(NIOServerConfig.self)
        
        // directory
        services.register { container -> DirectoryConfig in
            return DirectoryConfig.detect()
        }
        
        // templates
        services.register(ViewRenderer.self) { container -> PlaintextRenderer in
            let dir = try container.make(DirectoryConfig.self)
            return PlaintextRenderer.init(viewsDir: dir.workDir + "Resources/Views/", on: container)
        }
        
        try! services.register(FluentSQLiteProvider())
        try! services.register(LeafProvider())
        
        return services
    }
}
