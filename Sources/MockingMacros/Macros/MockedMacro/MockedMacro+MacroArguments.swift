//
//  MockedMacro+MacroArguments.swift
//
//  Copyright © 2025 Fetch.
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
        let compilationCondition: MockCompilationCondition
        
        // TODO: Docs
        let sendableConformance: MockSendableConformance

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

            var compilationCondition: MockCompilationCondition?

            if let compilationConditionArgument = argument(0) {
                compilationCondition = MockCompilationCondition(
                    argument: compilationConditionArgument
                )
            }

            self.compilationCondition = compilationCondition ?? .swiftMockingEnabled
            
            var sendableConformance: MockSendableConformance?
            if let sendableConformanceArgument = argument(1) {
                sendableConformance = MockSendableConformance(
                    argument: sendableConformanceArgument
                )
            }
            self.sendableConformance = sendableConformance ?? .checked
        }
    }
}
