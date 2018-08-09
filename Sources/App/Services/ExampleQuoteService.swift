//
//  ExampleQuoteService.swift
//  App
//
//  Created by marc on 2018.08.03.
//

import Vapor

public struct ExampleQuoteService: ExampleService {
    private let quotes = [
    "Life is really simple, but we insist on making it complicated. ~ Confucious",
    "That's been one of my mantras - focus and simplicity. ~ Steve Jobs",
    "My key to dealing with stress is simple: just stay cool and stay focused. ~ Ashton Eaton",
    "Everything should be made as simple as possible, but not simpler. ~ Albert Einstein"
    ]
    
    public func getRandomMessage() -> String {
        let random = Int(arc4random_uniform(UInt32(quotes.count)))
        return quotes[random]
    }
}

extension ExampleQuoteService: ServiceType {
    public static var serviceSupports: [Any.Type] {
        return [ExampleService.self]
    }
    
    public static func makeService(for worker: Container) throws -> ExampleQuoteService {
        return ExampleQuoteService()
    }
}
