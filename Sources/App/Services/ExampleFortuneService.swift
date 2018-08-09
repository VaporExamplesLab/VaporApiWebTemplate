//
//  ExampleFortuneService.swift
//  App
//
//  Created by marc on 2018.08.03.
//

import Vapor

public struct ExampleFortuneService: ExampleService {
    private let fortunes = [
    "Do not mistake temptation for opportunity.",
    "New experiences await at future horizons.",
    "One who throws dirt is losing ground.",
    "Courage is not simply one of the virtues, but the form of every virtue at the testing point.",
    "All things are difficult before they are easy."
    ]
    
    public func getRandomMessage() -> String {
        let random = Int(arc4random_uniform(UInt32(fortunes.count)))
        return fortunes[random]
    }

}

extension ExampleFortuneService: ServiceType {
    public static var serviceSupports: [Any.Type] {
        return [ExampleService.self]
    }
    
    public static func makeService(for worker: Container) throws -> ExampleFortuneService {
        return ExampleFortuneService()
    }
}
