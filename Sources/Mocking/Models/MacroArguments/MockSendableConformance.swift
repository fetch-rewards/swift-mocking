//
//  MockSendableConformance.swift
//
//  Copyright © 2025 Fetch.
//

/// A `Sendable` conformance that can be applied to a mock declaration.
public enum MockSendableConformance {

    /// The mock conforms to the protocol it is mocking, resulting in
    /// checked `Sendable` conformance if the protocol inherits from
    /// `Sendable`.
    case checked

    /// The mock conforms to `@unchecked Sendable`.
    case unchecked
}
