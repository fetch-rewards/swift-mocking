//
//  main.swift
//  MockedClient
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
public import Mocked

/// A protocol for testing/verifying Mocked's expansion.
///
/// - Important: Only use this for temporary testing/verification of Mocked's
///   expansion. Assume that anything added to this protocol can and will be
///   removed or replaced at some point in the future.
@Mocked
public protocol Playground {}

// MARK: Initializers

/// A protocol for verifying Mocked's handling of initializers.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of initializers. For temporary testing of Mocked's
///   expansion, use the ``Playground`` protocol.
@Mocked
public protocol Initializers {
    init(parameter: Int)
    init(parameters: Int...)
    init(parameter1: Int, parameter2: Int)
}

// MARK: Variadic Parameters

/// A protocol for verifying Mocked's handling of variadic parameters.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of variadic parameters. For temporary testing of
///   Mocked's expansion, use the ``Playground`` protocol.
@Mocked
public protocol VariadicParameters {
    func method(strings: String..., integers: Int...)
}

// MARK: Generic Methods

/// A protocol for verifying Mocked's handling of generic methods.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of generic methods. For temporary testing of Mocked's
///   expansion, use the ``Playground`` protocol.
@Mocked
public protocol GenericMethods {
    func genericMethodWithArrayType<Element>(
        array: [Element]
    ) -> [Element]

    func genericMethodWithAttributedType<Value>(
        value: inout Value
    )

    func genericMethodWithDictionaryType<Value>(
        dictionary: Dictionary<String, Value>
    ) -> [String: Value]

    func genericMethodWithGenericIdentifierType<Value>(
        value: Optional<Value>
    ) -> Optional<Value>

    func genericMethodWithIdentifierType<Value>(
        value: Value
    ) -> Value

    func genericMethodWithMetatypeType<Value>(
        valueType: Value.Type
    ) -> Value.Type
}

// MARK: Static Members

/// A protocol for verifying Mocked's handling of static properties and methods.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of static properties and methods. For temporary testing
///   of Mocked's expansion, use the ``Playground`` protocol.
@Mocked
public protocol StaticMembers {
    static var staticReadOnlyAsyncProperty: Int { get async }
    static var staticReadOnlyAsyncThrowingProperty: Int { get async throws }
    static var staticReadOnlyProperty: Int { get }
    static var staticReadOnlyThrowingProperty: Int { get throws }
    static var staticReadWriteProperty: Int { get set }

    var readOnlyAsyncProperty: Int { get async }
    var readOnlyAsyncThrowingProperty: Int { get async throws }
    var readOnlyProperty: Int { get }
    var readOnlyThrowingProperty: Int { get throws }
    var readWriteProperty: Int { get set }

    static func staticReturningAsyncMethodWithoutParameters() async -> Int
    static func staticReturningAsyncMethodWithParameters(parameter: Int) async -> Int
    static func staticReturningAsyncThrowingMethodWithoutParameters() async throws -> Int
    static func staticReturningAsyncThrowingMethodWithParameters(parameter: Int) async throws -> Int
    static func staticReturningMethodWithoutParameters() -> Int
    static func staticReturningMethodWithParameters(parameter: Int) -> Int
    static func staticReturningThrowingMethodWithoutParameters() throws -> Int
    static func staticReturningThrowingMethodWithParameters(parameter: Int) throws -> Int

    func returningAsyncMethodWithoutParameters() async -> Int
    func returningAsyncMethodWithParameters(parameter: Int) async -> Int
    func returningAsyncThrowingMethodWithoutParameters() async throws -> Int
    func returningAsyncThrowingMethodWithParameters(parameter: Int) async throws -> Int
    func returningMethodWithoutParameters() -> Int
    func returningMethodWithParameters(parameter: Int) -> Int
    func returningThrowingMethodWithoutParameters() throws -> Int
    func returningThrowingMethodWithParameters(parameter: Int) throws -> Int

    static func staticVoidAsyncMethodWithoutParameters() async
    static func staticVoidAsyncMethodWithParameters(parameter: Int) async
    static func staticVoidAsyncThrowingMethodWithoutParameters() async throws
    static func staticVoidAsyncThrowingMethodWithParameters(parameter: Int) async throws
    static func staticVoidMethodWithoutParameters()
    static func staticVoidMethodWithParameters(parameter: Int)
    static func staticVoidThrowingMethodWithoutParameters() throws
    static func staticVoidThrowingMethodWithParameters(parameter: Int) throws

    func voidAsyncMethodWithoutParameters() async
    func voidAsyncMethodWithParameters(parameter: Int) async
    func voidAsyncThrowingMethodWithoutParameters() async throws
    func voidAsyncThrowingMethodWithParameters(parameter: Int) async throws
    func voidMethodWithoutParameters()
    func voidMethodWithParameters(parameter: Int)
    func voidThrowingMethodWithoutParameters() throws
    func voidThrowingMethodWithParameters(parameter: Int) throws
}
