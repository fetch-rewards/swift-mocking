//
//  MockThrowingImplementation.swift
//  Mockable
//
//  Created by Cole Campbell on 11/11/23.
//

import Foundation
import XCTestDynamicOverlay

public enum MockThrowingImplementation<Value> {
    
    // MARK: Cases
    
    case unimplemented
    case returns(Value)
    case `throws`(Error)

    // MARK: Call As Function

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
