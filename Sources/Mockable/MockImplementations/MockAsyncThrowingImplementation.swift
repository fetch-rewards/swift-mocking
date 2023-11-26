//
//  MockAsyncThrowingImplementation.swift
//  Mockable
//
//  Created by Cole Campbell on 11/11/23.
//

import Foundation
import XCTestDynamicOverlay

public enum MockAsyncThrowingImplementation<Value> {
    case unimplemented
    case returns(() async -> Value)
    case `throws`(() async -> Error)

    func callAsFunction(description: MockImplementationDescription) async throws -> Value {
        await switch self {
        case .unimplemented:
            XCTestDynamicOverlay.unimplemented("\(description)")
        case .returns(let value):
            value()
        case .throws(let error):
            throw error()
        }
    }
}
