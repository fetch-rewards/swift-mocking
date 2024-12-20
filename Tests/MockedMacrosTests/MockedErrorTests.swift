//
//  MockedErrorTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct MockedErrorTests {

    // MARK: Typealiases

    typealias SUT = MockedError

    // MARK: Description Tests

    @Test(arguments: SUT.allCases)
    func description(sut: SUT) {
        let expectedDescription = switch sut {
        case .canOnlyBeAppliedToProtocols:
            "@Mocked can only be applied to protocols"
        }

        #expect(sut.description == expectedDescription)
    }
}
#endif
