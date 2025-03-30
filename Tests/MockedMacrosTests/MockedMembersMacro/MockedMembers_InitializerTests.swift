//
//  MockedMembers_InitializerTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 3/30/25.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

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
