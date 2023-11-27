//
//  MockAsyncImplementation.swift
//  Mockable
//
//  Created by Cole Campbell on 11/11/23.
//

import Foundation
import XCTestDynamicOverlay

public enum MockAsyncImplementation<Value> {

    // MARK: Cases

    case unimplemented
    case returns(() async -> Value)

    // MARK: Call As Function

    func callAsFunction(description: MockImplementationDescription) async -> Value {
        await switch self {
        case .unimplemented:
            XCTestDynamicOverlay.unimplemented("\(description)")
        case .returns(let value):
            value()
        }
    }
}
