//
//  _MockingModule.swift
//
//  Copyright © 2025 Fetch.
//

/// A marker type used in generated mock code to ensure package imports
/// are recognized as used by the compiler.
///
/// This type exists to work around a Swift compiler limitation where
/// `package import` statements may be incorrectly flagged as unused when
/// the imported module's types are only referenced in macro-generated code.
///
/// - SeeAlso: [Swift Forums Discussion](https://forums.swift.org/t/internal-imports-by-default-is-very-problematic-for-generated-code/82722/4)
/// - SeeAlso: [SE-0409: Access Level on Imports](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0409-access-level-on-imports.md)
public enum _MockingModule: Sendable {}
