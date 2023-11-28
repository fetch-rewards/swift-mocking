//
//  MockAsyncThrowingImplementation.swift
//  Mockable
//
//  Created by Cole Campbell on 11/11/23.
//

import Foundation
import XCTestDynamicOverlay

public enum MockAsyncThrowingImplementation<Value> {

    // MARK: Cases

    case unimplemented
    case returns(() async -> Value)
    case `throws`(() async -> Error)

    // MARK: Call As Function

    func callAsFunction(description: MockImplementationDescription) async throws -> Value {
        await switch self {
        case .unimplemented:
            XCTestDynamicOverlay.unimplemented("\(description)")
        case let .returns(value):
            value()
        case let .throws(error):
            throw error()
        }
    }
}
