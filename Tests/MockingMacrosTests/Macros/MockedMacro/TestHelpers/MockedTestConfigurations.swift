//
//  MockedTestConfigurations.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import SwiftSyntaxSugar

var mockedTestConfigurations: [(InterfaceConfiguration, MockConfiguration)] {
    AccessLevelSyntax.allCases.map { accessLevel in
        (
            InterfaceConfiguration(accessLevel: accessLevel),
            MockConfiguration(interfaceAccessLevel: accessLevel)
        )
    }
}
#endif
