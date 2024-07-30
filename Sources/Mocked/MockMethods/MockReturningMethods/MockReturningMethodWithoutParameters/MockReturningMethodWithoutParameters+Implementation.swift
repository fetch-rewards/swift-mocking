//
//  MockReturningMethodWithoutParameters+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockReturningMethodWithoutParameters {

    /// An implementation for a mock's returning method without parameters.
    public enum Implementation {

        // MARK: Cases

        /// Triggers a test failure when invoked.
        case unimplemented

        /// Returns a value when invoked.
        case returns(() -> ReturnValue)

        // MARK: Constructors

        /// Returns a value when invoked.
        public static func returns(_ value: ReturnValue) -> Self {
            .returns { value }
        }

        // MARK: Call As Function

        /// Invokes the implementation, triggering a test failure if the
        /// implementation is ``unimplemented`` or returning a value if the
        /// implementation is ``returns(_:)-swift.enum.case`` or
        /// ``returns(_:)-swift.type.method``.
        ///
        /// - Parameter description: The implementation's description.
        /// - Returns: A value, if the implementation is
        ///   ``returns(_:)-swift.enum.case`` or
        ///   ``returns(_:)-swift.type.method``.
        func callAsFunction(
            description: MockImplementationDescription
        ) -> ReturnValue {
            switch self {
            case .unimplemented:
                XCTestDynamicOverlay.unimplemented("\(description)")
            case let .returns(value):
                value()
            }
        }
    }
}
