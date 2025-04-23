//
//  MockedMacroTests+TestConfigurations.swift
//  MockingMacrosTests
//
//  Created by Gray Campbell on 1/21/25.
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
