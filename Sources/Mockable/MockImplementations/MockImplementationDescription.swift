//
//  MockImplementationDescription.swift
//  Mockable
//
//  Created by Cole Campbell on 11/25/23.
//

import Foundation

public struct MockImplementationDescription {
    let type: String
    let member: String

    public init(type: String, member: String) {
        self.type = type
        self.member = member
    }
}

extension MockImplementationDescription: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(self.type).\(self.member)"
    }
}
