//
//  MockedMembers_SubscriptOverloadsTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedMembers_SubscriptOverloadsTests {

    // MARK: Subscript Overloads Tests

    @Test
    func subscriptOverloadsWithDifferentParameterNames() {
        assertMockedMembers(
            """
            final class Mock {
                @MockableSubscript(.readOnly)
                subscript(key: String) -> String?
                @MockableSubscript(.readOnly)
                subscript(index: Int) -> String?
            }
            """,
            generates: """
            final class Mock {
                @MockableSubscript(.readOnly)
                @_MockedSubscript(
                \t.readOnly,
                \tmockName: "Mock",
                \tisMockAnActor: false,
                \tmockSubscriptName: "subscriptKey"
                )
                subscript(key: String) -> String?
                @MockableSubscript(.readOnly)
                @_MockedSubscript(
                \t.readOnly,
                \tmockName: "Mock",
                \tisMockAnActor: false,
                \tmockSubscriptName: "subscriptIndex"
                )
                subscript(index: Int) -> String?

                init() {
                }
            }
            """
        )
    }

    @Test
    func subscriptOverloadsWithDifferentParameterTypes() {
        assertMockedMembers(
            """
            final class Mock {
                @MockableSubscript(.readOnly)
                subscript(key: String) -> String?
                @MockableSubscript(.readOnly)
                subscript(key: Int) -> String?
            }
            """,
            generates: """
            final class Mock {
                @MockableSubscript(.readOnly)
                @_MockedSubscript(
                \t.readOnly,
                \tmockName: "Mock",
                \tisMockAnActor: false,
                \tmockSubscriptName: "subscriptKeyStringReturningOptionalString"
                )
                subscript(key: String) -> String?
                @MockableSubscript(.readOnly)
                @_MockedSubscript(
                \t.readOnly,
                \tmockName: "Mock",
                \tisMockAnActor: false,
                \tmockSubscriptName: "subscriptKeyIntReturningOptionalString"
                )
                subscript(key: Int) -> String?

                init() {
                }
            }
            """
        )
    }

    @Test
    func subscriptOverloadsWithAndWithoutDefaultValueSameKeyType() {
        assertMockedMembers(
            """
            final class Mock {
                @MockableSubscript(.readOnly)
                subscript(key: String) -> String?
                @MockableSubscript(.readOnly)
                subscript(key: String, default defaultValue: String) -> String?
            }
            """,
            generates: """
            final class Mock {
                @MockableSubscript(.readOnly)
                @_MockedSubscript(
                \t.readOnly,
                \tmockName: "Mock",
                \tisMockAnActor: false,
                \tmockSubscriptName: "subscriptKeyReturningOptionalString"
                )
                subscript(key: String) -> String?
                @MockableSubscript(.readOnly)
                @_MockedSubscript(
                \t.readOnly,
                \tmockName: "Mock",
                \tisMockAnActor: false,
                \tmockSubscriptName: "subscriptKeyDefaultDefaultValue"
                )
                subscript(key: String, default defaultValue: String) -> String?

                init() {
                }
            }
            """
        )
    }

    @Test
    func subscriptOverloadsWithAndWithoutDefaultValueDifferentKeyTypes() {
        assertMockedMembers(
            """
            final class Mock {
                @MockableSubscript(.readOnly)
                subscript(key: String) -> String?
                @MockableSubscript(.readOnly)
                subscript(key: Int, default defaultValue: String) -> String?
            }
            """,
            generates: """
            final class Mock {
                @MockableSubscript(.readOnly)
                @_MockedSubscript(
                \t.readOnly,
                \tmockName: "Mock",
                \tisMockAnActor: false,
                \tmockSubscriptName: "subscriptKeyReturningOptionalString"
                )
                subscript(key: String) -> String?
                @MockableSubscript(.readOnly)
                @_MockedSubscript(
                \t.readOnly,
                \tmockName: "Mock",
                \tisMockAnActor: false,
                \tmockSubscriptName: "subscriptKeyDefaultDefaultValue"
                )
                subscript(key: Int, default defaultValue: String) -> String?

                init() {
                }
            }
            """
        )
    }
}
#endif
