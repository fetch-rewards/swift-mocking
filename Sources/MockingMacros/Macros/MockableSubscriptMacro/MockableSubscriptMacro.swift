//
//  MockableSubscriptMacro.swift
//
//  Copyright © 2026 Fetch.
//

public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros
import SwiftSyntaxSugar

public struct MockableSubscriptMacro: AccessorMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        // The @MockableSubscript macro is used only as a marker to provide
        // information for the @MockedMembers macro and therefore does not
        // produce an expansion.
        []
    }
}
