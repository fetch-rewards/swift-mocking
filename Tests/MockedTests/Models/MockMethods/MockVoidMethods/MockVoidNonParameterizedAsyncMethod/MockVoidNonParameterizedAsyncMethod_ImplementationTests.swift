//
//  MockVoidNonParameterizedAsyncMethod_ImplementationTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 3/18/25.
//

import Testing
@testable import Mocked

struct MockVoidNonParameterizedAsyncMethod_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockVoidNonParameterizedAsyncMethod

    // MARK: Call As Function Tests

    @Test
    func unimplemented() async {
        await confirmation(expectedCount: .zero) { confirmation in
            let sut: SUT = .unimplemented

            await sut()
        }
    }

    @Test
    func uncheckedInvokes() async {
        await confirmation(expectedCount: 1) { confirmation in
            let sut: SUT = .uncheckedInvokes {
                confirmation.confirm()
            }

            await sut()
        }
    }

    @Test
    func invokes() async {
        await confirmation(expectedCount: 1) { confirmation in
            let sut: SUT = .invokes {
                confirmation.confirm()
            }

            await sut()
        }
    }
}
