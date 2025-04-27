//
//  MockSendableConformance.swift
//
//  Copyright © 2025 Fetch.
//

import SwiftSyntax

// TODO: Docs
enum MockSendableConformance: String, MacroArgument {
    
    // TODO: Docs
    case checked
    
    // TODO: Docs
    case unchecked
    
    // TODO: Docs
    init?(argument: LabeledExprSyntax) {
        guard
            let memberAccessExpression = argument.expression.as(
                MemberAccessExprSyntax.self
            ),
            let identifier = memberAccessExpression.declName.baseName.identifier
        else {
            return nil
        }
        self.init(rawValue: identifier.name)
    }
}
