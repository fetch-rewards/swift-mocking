//
//  MockedMacroTests+TestConfigurations.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/21/25.
//

#if canImport(MockedMacros)
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
