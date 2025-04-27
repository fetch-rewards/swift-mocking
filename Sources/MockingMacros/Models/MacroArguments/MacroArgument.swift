//
//  MacroArgument.swift
//
//  Copyright © 2025 Fetch.
//

import SwiftSyntax

// TODO: Docs
protocol MacroArgument {
    init?(argument: LabeledExprSyntax)
}
