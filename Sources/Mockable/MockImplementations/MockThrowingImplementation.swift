//
//  MockThrowingImplementation.swift
//  Mockable
//
//  Created by Cole Campbell on 11/11/23.
//

import Foundation
import XCTestDynamicOverlay

public enum MockThrowingImplementation<Value> {
    case unimplemented
    case returns(Value)
    case `throws`(Error)

    func callAsFunction(description: MockImplementationDescription) throws -> Value {
        switch self {
        case .unimplemented:
            XCTestDynamicOverlay.unimplemented("\(description)")
        case .returns(let value):
            value
        case .throws(let error):
            throw error
        }
    }
}
