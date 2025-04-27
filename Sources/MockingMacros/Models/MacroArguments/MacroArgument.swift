//
//  MacroArgument.swift
//
//  Copyright © 2025 Fetch.
//

import SwiftSyntax

/// A protocol for arguments that can be parsed from a macro's argument
/// syntax.
protocol MacroArgument {

    /// Creates a macro argument from the provided `argument`.
    ///
    /// - Parameter argument: The argument syntax from which to parse the
    ///   macro argument.
    init?(argument: LabeledExprSyntax)
}
