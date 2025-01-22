//
//  MockedMacro_MacroErrorTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct MockedMacro_MacroErrorTests {

    // MARK: Typealiases

    typealias SUT = MockedMacro.MacroError

    // MARK: Description Tests

    @Test(arguments: SUT.allCases)
    func description(sut: SUT) {
        let expectedDescription = switch sut {
        case .canOnlyBeAppliedToProtocols:
            "@Mocked can only be applied to protocols."
        case .unableToParsePropertyBindingName:
            "@Mocked was unable to parse a property binding name."
        }

        #expect(sut.description == expectedDescription)
    }
}
#endif
