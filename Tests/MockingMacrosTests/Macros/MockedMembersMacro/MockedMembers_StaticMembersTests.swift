//
//  MockedMembers_StaticMembersTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedMembers_StaticMembersTests {

    // MARK: Static Members Tests

    @Test
    func staticPropertyWithBacktickedName() {
        assertMockedMembers(
            """
            final class Mock {
                @MockableProperty(.readOnly)
                static var `default`: String
            }
            """,
            generates: """
            final class Mock {
                @MockableProperty(.readOnly)
                @_MockedProperty(
                \t.readOnly,
                \tmockName: "Mock",
                \tisMockAnActor: false
                )
                static var `default`: String

                init() {
                }

                /// Resets the implementations and invocation records of the mock's 
                /// static properties and methods.
                static func resetMockedStaticMembers() {
                    self.__default.reset()
                }
            }
            """
        )
    }
}
#endif
