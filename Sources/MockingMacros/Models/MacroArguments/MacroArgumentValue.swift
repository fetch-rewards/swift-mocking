//
//  MacroArgumentValue.swift
//
//  Copyright © 2025 Fetch.
//

import SwiftSyntax

/// A protocol for argument values that can be parsed from a macro's argument
/// syntax.
protocol MacroArgumentValue {

    /// Creates an instance from the provided `argument`.
    ///
    /// - Parameter argument: The argument syntax from which to parse the
    ///   macro argument value.
    init?(argument: LabeledExprSyntax)
}
