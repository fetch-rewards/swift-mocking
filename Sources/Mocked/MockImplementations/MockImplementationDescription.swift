//
//  MockImplementationDescription.swift
//  Mocked
//
//  Created by Cole Campbell on 11/25/23.
//

import Foundation

/// A mock implementation's description.
public struct MockImplementationDescription {

    // MARK: Properties

    /// The description of the mock's type.
    private let type: String

    /// The description of the mock's member.
    private let member: String

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

// MARK: - CustomDebugStringConvertible

extension MockImplementationDescription: CustomDebugStringConvertible {

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
}
