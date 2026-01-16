//
//  Mocked_IfConfigDeclTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct Mocked_IfConfigDeclTests {

    // MARK: Initializer in #if Block Tests

    @Test(arguments: mockedTestConfigurations)
    func initializerInIfBlock(
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

    // MARK: Initializer in #if/#else Block Tests

    @Test(arguments: mockedTestConfigurations)
    func initializerInIfElseBlock(
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

    // MARK: Property in #if Block Tests

    @Test(arguments: mockedTestConfigurations)
    func propertyInIfBlock(
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

    // MARK: Property in #if/#else Block Tests

    @Test(arguments: mockedTestConfigurations)
    func propertyInIfElseBlock(
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

    // MARK: Method in #if Block Tests

    @Test(arguments: mockedTestConfigurations)
    func methodInIfBlock(
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

    // MARK: Method in #if/#else Block Tests

    @Test(arguments: mockedTestConfigurations)
    func methodInIfElseBlock(
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

    // MARK: Multiple Members in #if Block Tests

    @Test(arguments: mockedTestConfigurations)
    func multipleMembersInIfBlock(
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

    // MARK: #if/#elseif/#else Chain Tests

    @Test(arguments: mockedTestConfigurations)
    func ifElseifElseChain(
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

    // MARK: Associated Type in #if Block Tests

    @Test(arguments: mockedTestConfigurations)
    func associatedTypeInIfBlock(
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

    // MARK: Associated Type with Different Constraints in #if/#else Tests

    @Test(arguments: mockedTestConfigurations)
    func associatedTypeWithDifferentConstraintsInIfElseBlock(
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

    @Test(arguments: mockedTestConfigurations)
    func associatedTypeWithDifferentConstraintsInIfElseifElseChain(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol PlatformCollection {
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
            \(mock.modifiers)class PlatformCollectionMock<Element> {
            }
            #if os(iOS)
            extension PlatformCollectionMock: PlatformCollection where Element: Equatable {
            }
            #elseif os(macOS)
            extension PlatformCollectionMock: PlatformCollection where Element: Hashable {
            }
            #else
            extension PlatformCollectionMock: PlatformCollection where Element: Codable {
            }
            #endif
            #endif
            """
        )
    }

    @Test(arguments: mockedTestConfigurations)
    func associatedTypeWithMultipleConstraintsInIfElseBlock(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol MultiConstraintCollection {
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
            \(mock.modifiers)class MultiConstraintCollectionMock<Item> {
            }
            #if DEBUG
            extension MultiConstraintCollectionMock: MultiConstraintCollection where Item: Equatable, Item: Sendable {
            }
            #else
            extension MultiConstraintCollectionMock: MultiConstraintCollection where Item: Hashable, Item: Codable {
            }
            #endif
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
