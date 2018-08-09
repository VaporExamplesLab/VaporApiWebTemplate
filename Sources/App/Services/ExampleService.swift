//
//  ExampleService.swift
//  App
//
//  Created by marc on 2018.08.03.
//

import Vapor

/// ExampleService provides a random message.
public protocol ExampleService {
    
    /// - returns: A random message
    func getRandomMessage() -> String
    
}
