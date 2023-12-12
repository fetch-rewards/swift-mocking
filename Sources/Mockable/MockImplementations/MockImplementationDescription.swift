//
//  MockImplementationDescription.swift
//  Mockable
//
//  Created by Cole Campbell on 11/25/23.
//

import Foundation

public struct MockImplementationDescription {

    // MARK: Properties

    private let type: String
    private let member: String

    // MARK: Initializers

    public init<Type>(type: Type.Type, member: String) {
        self.type = String(describing: type)
        self.member = member
    }
}

// MARK: - CustomDebugStringConvertible

extension MockImplementationDescription: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(self.type).\(self.member)"
    }
}
