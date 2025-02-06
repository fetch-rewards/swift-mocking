//
//  MockedMembers_MethodOverloadsTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 2/2/25.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

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
