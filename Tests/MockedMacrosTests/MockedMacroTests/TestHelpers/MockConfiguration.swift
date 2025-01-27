//
//  MockConfiguration.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/21/25.
//

#if canImport(MockedMacros)
import SwiftSyntaxSugar

struct MockConfiguration {

    // MARK: Properties

    let accessLevel: AccessLevelSyntax
    let modifiers: String
    let memberModifiers: String

    // MARK: Initializers

    init(interfaceAccessLevel: AccessLevelSyntax) {
        let accessLevel: AccessLevelSyntax = switch interfaceAccessLevel {
        case .fileprivate, .internal, .open, .package, .public:
            interfaceAccessLevel
        case .private:
            .fileprivate
        }

        let modifiers: String
        let memberModifiers: String

        switch accessLevel {
        case .fileprivate, .open, .package, .private, .public:
            modifiers = "\(accessLevel) final "
            memberModifiers = "\(accessLevel) "
        case .internal:
            modifiers = "final "
            memberModifiers = ""
        }

        self.accessLevel = accessLevel
        self.modifiers = modifiers
        self.memberModifiers = memberModifiers
    }
}
#endif
