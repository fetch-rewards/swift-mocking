import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxSugar

public struct MockableMacro: PeerMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        [""]
    }
}

// MARK: - Plugin

@main
struct MockablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MockableMacro.self
    ]
}
