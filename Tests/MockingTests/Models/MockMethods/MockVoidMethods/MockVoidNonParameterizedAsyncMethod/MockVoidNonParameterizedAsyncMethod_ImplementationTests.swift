//
//  MockVoidNonParameterizedAsyncMethod_ImplementationTests.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Testing
@testable import Mocking

struct MockVoidNonParameterizedAsyncMethod_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockVoidNonParameterizedAsyncMethod

    // MARK: Call As Function Tests

    @Test
    func unimplemented() async {
        await confirmation(expectedCount: .zero) { _ in
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
