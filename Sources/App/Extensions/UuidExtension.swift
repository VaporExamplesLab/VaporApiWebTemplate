//
//  Extensions.swift
//  App
//
//  Created by marc on 2018.08.05.
//

import Foundation

public extension UUID {
    /// lowercased string per RFC 4122 section 3 guidelines
    public var rfc4122String: String {
        return self.uuidString.lowercased()
    }
}
