//
//  MockablePropertyMacro.swift
//  Mocked
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
        []
    }
}
