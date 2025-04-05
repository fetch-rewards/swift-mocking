//
//  MockedMembers_MethodOverloadsTests.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedMembers_MethodOverloadsTests {

    // MARK: Method Overloads Tests

    @Test
    func methodOverloads() {
        assertMockedMembers(
            """
            final class Mock {
                func method()
                func method() -> String
            }
            """,
            generates: """
            final class Mock {
                @_MockedMethod(
                \tmockName: "Mock",
                \tisMockAnActor: false,
                \tmockMethodName: "method"
                )
                func method()
                @_MockedMethod(
                \tmockName: "Mock",
                \tisMockAnActor: false,
                \tmockMethodName: "methodReturningString"
                )
                func method() -> String
            
                init() {
                }
            }
            """
        )
    }
}
#endif
