//
//  MockVoidNonParameterizedAsyncMethodTests.swift
//
//  Copyright © 2025 Fetch.
//

import Testing
@testable import Mocking

struct MockVoidNonParameterizedAsyncMethodTests {

    // MARK: Typealiases

    typealias SUT = MockVoidNonParameterizedAsyncMethod

    // MARK: Implementation Tests

    @Test
    func implementation() async {
        let (sut, invoke, reset) = SUT.makeMethod()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }

        await confirmation(expectedCount: 1) { confirmation in
            sut.implementation = .uncheckedInvokes {
                confirmation.confirm()
            }

            _ = await invoke()
        }

        reset()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    @Test
    func callCount() async throws {
        let (sut, invoke, reset) = SUT.makeMethod()

        #expect(sut.callCount == .zero)

        try await TestBarrier.executeConcurrently {
            await invoke()
        }
        #expect(sut.callCount == TestBarrier.defaultTaskCount)

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.callCount == .zero)
    }
}
