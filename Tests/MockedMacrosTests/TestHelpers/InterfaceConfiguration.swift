//
//  InterfaceConfiguration.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import SwiftSyntaxSugar
@testable import MockedMacros

struct InterfaceConfiguration {

    // MARK: Properties

    let accessLevel: AccessLevelSyntax
}
#endif
