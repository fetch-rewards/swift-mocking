//
//  Mocked_IfConfigDeclTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

/// Tests for IfConfigDeclSyntax support in mocked protocols.
struct Mocked_IfConfigDeclTests {

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
