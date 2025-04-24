//
//  MockVoidNonParameterizedMethodTests.swift
//
//  Copyright © 2025 Fetch.
//

import Testing
@testable import Mocking

struct MockVoidNonParameterizedMethodTests {

    // MARK: Typealiases

    typealias SUT = MockVoidNonParameterizedMethod

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

            _ = invoke()
        }

        reset()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    @Test
    func callCount() {
        let (sut, invoke, reset) = SUT.makeMethod()

        #expect(sut.callCount == .zero)

        invoke()
        #expect(sut.callCount == 1)

        reset()
        #expect(sut.callCount == .zero)
    }
}
