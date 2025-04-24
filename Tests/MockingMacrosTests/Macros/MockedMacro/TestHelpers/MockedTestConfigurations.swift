//
//  MockedTestConfigurations.swift
//
//  Copyright © 2025 Fetch.
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
