//
//  MockedMembersMacro+MemberMacro.swift
//  MockedMacros
//
//  Created by Gray Campbell on 1/15/25.
//

public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedMembersMacro: MemberMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            let resetMockedStaticMembersMethodDeclaration =
                self.resetMockedStaticMembersMethodDeclaration(for: declaration)
        else {
            return []
        }

        return [
            DeclSyntax(resetMockedStaticMembersMethodDeclaration),
        ]
    }

    // MARK: Reset Static Members Method

    /// Returns a `resetMockedStaticMembers` method declaration that, when
    /// invoked, resets the `static` backing override declarations used to mock
    /// the static members in the provided `declaration`.
    ///
    /// - Parameter declaration: The declaration to which to add the
    ///   `resetMockedStaticMembers` method declaration.
    /// - Returns: A `resetMockedStaticMembers` method declaration that, when
    ///   invoked, resets the `static` backing override declarations used to
    ///   mock the static members in the provided `declaration`.
    private static func resetMockedStaticMembersMethodDeclaration(
        for declaration: some DeclGroupSyntax
    ) -> FunctionDeclSyntax? {
        let members = declaration.memberBlock.members
        let staticMemberNames: [TokenSyntax] = members.compactMap { member in
            let modifiers: DeclModifierListSyntax
            let memberName: TokenSyntax

            if
                let propertyDeclaration = member.decl.as(VariableDeclSyntax.self),
                let propertyBinding = propertyDeclaration.bindings.first,
                let propertyBindingPattern = propertyBinding.pattern.as(
                    IdentifierPatternSyntax.self
                )
            {
                modifiers = propertyDeclaration.modifiers
                memberName = propertyBindingPattern.identifier
            } else if let methodDeclaration = member.decl.as(FunctionDeclSyntax.self) {
                modifiers = methodDeclaration.modifiers
                memberName = methodDeclaration.name
            } else {
                return nil
            }

            guard modifiers.contains(where: { modifier in
                modifier.name.tokenKind == .keyword(.static)
            }) else {
                return nil
            }

            return memberName
        }

        guard !staticMemberNames.isEmpty else {
            return nil
        }

        return FunctionDeclSyntax(
            leadingTrivia: """
            /// Resets the implementations and invocation records of the mock's 
            /// static properties and methods.\n
            """,
            modifiers: DeclModifierListSyntax {
                if
                    let accessLevelModifier = declaration.modifiers.first(
                        where: \.isAccessLevel
                    ),
                    accessLevelModifier.name.tokenKind != .keyword(.internal)
                {
                    accessLevelModifier.trimmed
                }

                DeclModifierSyntax(name: .keyword(.static))
            },
            funcKeyword: .keyword(.func),
            name: "resetMockedStaticMembers",
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(
                    leftParen: .leftParenToken(),
                    rightParen: .rightParenToken()
                ) {}
            )
        ) {
            for staticMemberName in staticMemberNames {
                "self.__\(staticMemberName).reset()"
            }
        }
    }
}
