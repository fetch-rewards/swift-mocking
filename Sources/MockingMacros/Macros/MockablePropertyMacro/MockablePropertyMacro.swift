//
//  MockablePropertyMacro.swift
//  MockingMacros
//
//  Created by Gray Campbell on 1/19/25.
//

public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros
import SwiftSyntaxSugar

public struct MockablePropertyMacro: AccessorMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        // The @MockableProperty macro is used only as a marker to provide
        // information for the @MockedMembers macro and therefore does not
        // produce an expansion.
        []
    }
}
