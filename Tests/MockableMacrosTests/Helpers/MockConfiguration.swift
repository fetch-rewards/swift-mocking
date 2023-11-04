//
//  MockConfiguration.swift
//  MockableMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockableMacros)
import MockableMacros
import SwiftSyntaxSugar

struct MockConfiguration {

    // MARK: Properties

    let accessLevel: AccessLevelSyntax
    let modifiers: String
    let memberModifiers: String
    let defaultInit: String

    // MARK: Initializers

    init(interfaceAccessLevel: AccessLevelSyntax) {
        // TODO: Remove default
        let accessLevel: AccessLevelSyntax =
            switch interfaceAccessLevel {
            case .private: .fileprivate
            default: interfaceAccessLevel
            }

        let modifiers: String
        let memberModifiers: String

        // TODO: Remove default
        switch accessLevel {
        case .internal:
            modifiers = "final "
            memberModifiers = ""
        default:
            modifiers = "\(accessLevel) final "
            memberModifiers = "\(accessLevel) "
        }

        self.accessLevel = accessLevel
        self.modifiers = modifiers
        self.memberModifiers = memberModifiers
        self.defaultInit = """
                \(memberModifiers)init() {
                }
            """
    }
}
#endif
