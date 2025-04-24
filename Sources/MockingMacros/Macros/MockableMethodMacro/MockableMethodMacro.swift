//
//  MockableMethodMacro.swift
//
//  Copyright © 2025 Fetch.
//

public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros
import SwiftSyntaxSugar

public struct MockableMethodMacro: BodyMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
        in context: some MacroExpansionContext
    ) throws -> [CodeBlockItemSyntax] {
        // The @MockableMethod macro is used only as a marker to provide
        // information for the @MockedMembers macro and therefore does not
        // produce an expansion.
        []
    }
}
