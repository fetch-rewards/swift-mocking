//
//  MockImplementationDescription.swift
//
//  Created by Cole Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation

/// A mock implementation's description.
public struct MockImplementationDescription: CustomDebugStringConvertible, Sendable {

    // MARK: Properties

    /// The description of the mock's type.
    private let type: String

    /// The description of the mock's member.
    private let member: String

    /// The description of the mock's implementation.
    ///
    /// ```swift
    /// let implementationDescription = MockImplementationDescription(
    ///     type: DependencyMock.self,
    ///     member: "_user"
    /// )
    ///
    /// print(implementationDescription.debugDescription) // "DependencyMock._user"
    /// ```
    ///
    /// - Returns: The description of the mock's implementation.
    public var debugDescription: String {
        "\(self.type).\(self.member)"
    }

    // MARK: Initializers

    /// Creates a mock implementation's description.
    ///
    /// ```swift
    /// let implementationDescription = MockImplementationDescription(
    ///     type: DependencyMock.self,
    ///     member: "_user"
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - type: The description of the mock's type.
    ///   - member: The description of the mock's member.
    public init<Type>(type: Type.Type, member: String) {
        self.type = String(describing: type)
        self.member = member
    }
}
