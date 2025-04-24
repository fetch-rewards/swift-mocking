//
//  MockedMembers_InitializerTests.swift
//
//  Copyright © 2025 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedMembers_InitializerTests {

    // MARK: Initializer Tests

    @Test
    func noInitializer() {
        assertMockedMembers(
            """
            final class Mock {
            }
            """,
            generates: """
            final class Mock {

                init() {
                }
            }
            """
        )
    }

    @Test
    func emptyInitializer() {
        assertMockedMembers(
            """
            final class Mock {
                init() {
                }
            }
            """,
            generates: """
            final class Mock {
                init() {
                }
            }
            """
        )
    }

    @Test
    func nonEmptyInitializer() {
        assertMockedMembers(
            """
            final class Mock {
                init(parameter: Int) {
                }
            }
            """,
            generates: """
            final class Mock {
                init(parameter: Int) {
                }

                init() {
                }
            }
            """
        )
    }
}
#endif
