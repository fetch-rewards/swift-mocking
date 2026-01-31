//
//  Mocked_IfConfigDeclarationTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct Mocked_IfConfigDeclarationTests {

    // MARK: Initializers in #if Statement Tests

    @Test(arguments: mockedTestConfigurations)
    func initializersInIfStatement(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                init()
                #if DEBUG
                init(debugParameter: String)
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
                \(mock.memberModifiers)init() {
                }
                #if DEBUG
                \(mock.memberModifiers)init(debugParameter: String) {
                }
                #endif
            }
            #endif
            """
        )
    }

    // MARK: Initializers in #if/#else Statement Tests

    @Test(arguments: mockedTestConfigurations)
    func initializersInIfElseStatement(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                #if os(iOS)
                init(iOSParameter: String)
                #else
                init(otherPlatformParameter: String)
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
                #if os(iOS)
                \(mock.memberModifiers)init(iOSParameter: String) {
                }
                #else
                \(mock.memberModifiers)init(otherPlatformParameter: String) {
                }
                #endif
            }
            #endif
            """
        )
    }

    // MARK: Properties in #if Statement Tests

    @Test(arguments: mockedTestConfigurations)
    func propertiesInIfStatement(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                var commonProperty: String { get }
                #if DEBUG
                var debugProperty: Int { get set }
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
                @MockableProperty(.readOnly)
                \(mock.memberModifiers)var commonProperty: String
                #if DEBUG
                @MockableProperty(.readWrite)
                \(mock.memberModifiers)var debugProperty: Int
                #endif
            }
            #endif
            """
        )
    }

    // MARK: Properties in #if/#else Statement Tests

    @Test(arguments: mockedTestConfigurations)
    func propertiesInIfElseStatement(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                #if os(iOS)
                var iOSProperty: String { get }
                #else
                var otherPlatformProperty: Int { get set }
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
                #if os(iOS)
                @MockableProperty(.readOnly)
                \(mock.memberModifiers)var iOSProperty: String
                #else
                @MockableProperty(.readWrite)
                \(mock.memberModifiers)var otherPlatformProperty: Int
                #endif
            }
            #endif
            """
        )
    }

    // MARK: Methods in #if Statement Tests

    @Test(arguments: mockedTestConfigurations)
    func methodsInIfStatement(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func commonMethod()
                #if DEBUG
                func debugOnlyMethod()
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
                \(mock.memberModifiers)func commonMethod()
                #if DEBUG
                \(mock.memberModifiers)func debugOnlyMethod()
                #endif
            }
            #endif
            """
        )
    }

    // MARK: Methods in #if/#else Statement Tests

    @Test(arguments: mockedTestConfigurations)
    func methodsInIfElseStatement(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                #if os(iOS)
                func iOSMethod()
                #else
                func otherPlatformMethod()
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
                #if os(iOS)
                \(mock.memberModifiers)func iOSMethod()
                #else
                \(mock.memberModifiers)func otherPlatformMethod()
                #endif
            }
            #endif
            """
        )
    }

    // MARK: Methods in #if/#elseif/#else Statement Tests

    @Test(arguments: mockedTestConfigurations)
    func methodsInIfElseifElseStatement(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                #if os(iOS)
                func iOSMethod()
                #elseif os(macOS)
                func macOSMethod()
                #else
                func otherMethod()
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
                #if os(iOS)
                \(mock.memberModifiers)func iOSMethod()
                #elseif os(macOS)
                \(mock.memberModifiers)func macOSMethod()
                #else
                \(mock.memberModifiers)func otherMethod()
                #endif
            }
            #endif
            """
        )
    }

    // MARK: Associated Types with Same Declaration in #if/#else Statement Tests

    @Test(arguments: mockedTestConfigurations)
    func associatedTypesWithSameDeclarationInIfElseStatement(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                #if os(iOS)
                associatedtype PlatformView
                #else
                associatedtype PlatformView
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock<PlatformView>: Dependency {
            }
            #endif
            """
        )
    }

    // MARK: Associated Types with Different Constraints in #if/#else Statement Tests

    @Test(arguments: mockedTestConfigurations)
    func associatedTypesWithDifferentConstraintsInIfElseStatement(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol SomeCollection {
                #if DEBUG
                associatedtype Item: Equatable
                #else
                associatedtype Item: Hashable
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class SomeCollectionMock<Item> {
            }
            #if DEBUG
            extension SomeCollectionMock: SomeCollection where Item: Equatable {
            }
            #else
            extension SomeCollectionMock: SomeCollection where Item: Hashable {
            }
            #endif
            #endif
            """
        )
    }

    // MARK: Associated Types with Different Constraints in #if/#elseif/#else Statement Tests

    @Test(arguments: mockedTestConfigurations)
    func associatedTypesWithDifferentConstraintsInIfElseifElseStatement(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol SomeCollection {
                associatedtype Key: Hashable
                #if os(iOS)
                associatedtype Element: Equatable
                #elseif os(macOS)
                associatedtype Element: Hashable
                #else
                associatedtype Element: Codable
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class SomeCollectionMock<Key: Hashable, Element> {
            }
            #if os(iOS)
            extension SomeCollectionMock: SomeCollection where Element: Equatable {
            }
            #elseif os(macOS)
            extension SomeCollectionMock: SomeCollection where Element: Hashable {
            }
            #else
            extension SomeCollectionMock: SomeCollection where Element: Codable {
            }
            #endif
            #endif
            """
        )
    }

    // MARK: Associated Types with Multiple Constraints in #if/#else Statement Tests

    @Test(arguments: mockedTestConfigurations)
    func associatedTypeWithMultipleConstraintsInIfElseStatement(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol SomeCollection {
                associatedtype Key: Hashable
                #if DEBUG
                associatedtype Item: Equatable & Sendable
                #else
                associatedtype Item: Hashable, Codable
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class SomeCollectionMock<Key: Hashable, Item> {
            }
            #if DEBUG
            extension SomeCollectionMock: SomeCollection where Item: Equatable & Sendable {
            }
            #else
            extension SomeCollectionMock: SomeCollection where Item: Hashable & Codable {
            }
            #endif
            #endif
            """
        )
    }

    // MARK: Associated Types with Different Generic Where Clauses in #if/#else Statement Tests

    @Test(arguments: mockedTestConfigurations)
    func associatedTypesWithDifferentGenericWhereClausesInIfElseStatement(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol SomeCollection {
                associatedtype Key: Hashable
                #if DEBUG
                associatedtype Base: RandomAccessCollection & Equatable where Base.Element: Equatable
                #else
                associatedtype Base: RandomAccessCollection, Codable where Base.Element: Codable
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class SomeCollectionMock<Key: Hashable, Base> {
            }
            #if DEBUG
            extension SomeCollectionMock: SomeCollection \
            where Base: RandomAccessCollection & Equatable, Base.Element: Equatable {
            }
            #else
            extension SomeCollectionMock: SomeCollection \
            where Base: RandomAccessCollection & Codable, Base.Element: Codable {
            }
            #endif
            #endif
            """
        )
    }

    // MARK: Associated Types with Different Generic Where Clauses in #if/#elseif/#else Statement Tests

    @Test(arguments: mockedTestConfigurations)
    func associatedTypesWithDifferentGenericWhereClausesInIfElseifElseStatement(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol SomeCollection {
                associatedtype Key: Hashable
                #if os(iOS)
                associatedtype Base: RandomAccessCollection where Base.Element: Equatable
                #elseif os(macOS)
                associatedtype Base: RandomAccessCollection where Base.Element: Hashable
                #else
                associatedtype Base: RandomAccessCollection where Base.Element: Codable
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class SomeCollectionMock<Key: Hashable, Base> {
            }
            #if os(iOS)
            extension SomeCollectionMock: SomeCollection \
            where Base: RandomAccessCollection, Base.Element: Equatable {
            }
            #elseif os(macOS)
            extension SomeCollectionMock: SomeCollection \
            where Base: RandomAccessCollection, Base.Element: Hashable {
            }
            #else
            extension SomeCollectionMock: SomeCollection \
            where Base: RandomAccessCollection, Base.Element: Codable {
            }
            #endif
            #endif
            """
        )
    }

    // MARK: Multiple Members in #if Statement Tests

    @Test(arguments: mockedTestConfigurations)
    func multipleMembersInIfStatement(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                #if DEBUG
                var debugProperty: Int { get }
                func debugMethod()
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
                #if DEBUG
                @MockableProperty(.readOnly)
                \(mock.memberModifiers)var debugProperty: Int
                \(mock.memberModifiers)func debugMethod()
                #endif
            }
            #endif
            """
        )
    }

    // MARK: OR Condition Tests

    @Test(arguments: mockedTestConfigurations)
    func orCondition(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func commonMethod()
                #if DEBUG || TESTFLIGHT
                func debugOrTestFlightMethod()
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
                \(mock.memberModifiers)func commonMethod()
                #if DEBUG || TESTFLIGHT
                \(mock.memberModifiers)func debugOrTestFlightMethod()
                #endif
            }
            #endif
            """
        )
    }

    // MARK: Nested #if Conditional Tests

    @Test(arguments: mockedTestConfigurations)
    func nestedIfConditionals(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                #if DEBUG
                func debugMethod()
                #if os(iOS)
                func debugiOSOnlyMethod()
                #endif
                #endif
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
                #if DEBUG
                \(mock.memberModifiers)func debugMethod()
                #if os(iOS)
                \(mock.memberModifiers)func debugiOSOnlyMethod()
                #endif
                #endif
            }
            #endif
            """
        )
    }
}
#endif
