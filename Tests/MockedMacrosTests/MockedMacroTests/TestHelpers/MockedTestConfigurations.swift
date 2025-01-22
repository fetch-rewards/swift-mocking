//
//  MockedMacroTests+TestConfigurations.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/21/25.
//

#if canImport(MockedMacros)
import SwiftSyntaxSugar

var mockedTestConfigurations: [(MockInterfaceConfiguration, MockConfiguration)] {
    AccessLevelSyntax.allCases.map { accessLevel in
        (
            MockInterfaceConfiguration(accessLevel: accessLevel),
            MockConfiguration(interfaceAccessLevel: accessLevel)
        )
    }
}
#endif
