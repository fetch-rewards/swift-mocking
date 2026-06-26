//
//  MockSubscriptSetter_ImplementationTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import Mocking

struct MockSubscriptSetter_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Setter.Implementation
    typealias Setter = MockSubscriptSetter<Arguments, Value>
    typealias Arguments = String
    typealias Value = Int

    // MARK: Call As Function Tests

    @Test
    func unimplemented() async {
        await confirmation(expectedCount: .zero) { _ in
            let sut: SUT = .unimplemented

            sut("a", 5)
        }
    }

    @Test
    func uncheckedInvokes() async {
        await confirmation(expectedCount: 1) { confirmation in
            let sut: SUT = .uncheckedInvokes { _, _ in
                confirmation.confirm()
            }

            sut("a", 5)
        }
    }

    @Test
    func invokes() async {
        await confirmation(expectedCount: 1) { confirmation in
            let sut: SUT = .invokes { _, _ in
                confirmation.confirm()
            }

            sut("a", 5)
        }
    }
}
