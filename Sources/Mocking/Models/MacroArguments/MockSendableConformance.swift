//
//  MockSendableConformance.swift
//
//  Copyright © 2025 Fetch.
//

/// A `Sendable` conformance that can be applied to a mock declaration.
public enum MockSendableConformance {
    
    /// The mock adheres to the `Sendable` conformance of the original
    /// implementation.
    case checked
    
    /// The mock conforms to `@unchecked Sendable`.
    case unchecked
}
