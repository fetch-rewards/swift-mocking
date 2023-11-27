//
//  MockImplementation.swift
//  Mockable
//
//  Created by Cole Campbell on 11/11/23.
//

import Foundation
import XCTestDynamicOverlay

public enum MockImplementation<Value> {

    // MARK: Cases

    case unimplemented
    case returns(Value)

    // MARK: Call As Function

    func callAsFunction(description: MockImplementationDescription) -> Value {
        switch self {
        case .unimplemented:
            XCTestDynamicOverlay.unimplemented("\(description)")
        case .returns(let value):
            value
        }
    }
}
