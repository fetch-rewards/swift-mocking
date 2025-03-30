//
//  MockedMacro+MacroArguments.swift
//  Mocked
//
//  Created by Gray Campbell on 3/30/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedMacro {

    /// Arguments provided to `@Mocked`.
    struct MacroArguments {

        // MARK: Properties

        /// The compilation condition with which to wrap the generated mock.
        let compilationCondition: String?

        // MARK: Initializers

        /// Creates macro arguments parsed from the provided `node`.
        ///
        /// - Parameter node: The node representing the macro.
        init(node: AttributeSyntax) {
            let arguments = node.arguments?.as(LabeledExprListSyntax.self)
            let argument: (Int) -> LabeledExprSyntax? = { index in
                guard let arguments else {
                    return nil
                }

                let argumentIndex = arguments.index(at: index)

                return arguments.count > index ? arguments[argumentIndex] : nil
            }

            self.compilationCondition = argument(0)?
                .expression
                .as(StringLiteralExprSyntax.self)?
                .representedLiteralValue
        }
    }
}
