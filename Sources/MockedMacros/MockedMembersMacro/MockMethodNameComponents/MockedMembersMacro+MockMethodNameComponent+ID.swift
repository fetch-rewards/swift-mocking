//
//  MockedMembersMacro+MockMethodNameComponent+ID.swift
//  MockedMacros
//
//  Created by Gray Campbell on 1/26/25.
//

import Foundation

extension MockedMembersMacro.MockMethodNameComponent {

    /// A mock method name component ID.
    enum ID: Hashable {

        // MARK: Cases

        /// The method's name.
        case methodName

        /// One of the method's parameter names.
        ///
        /// - Parameter index: The index of the parameter.
        case parameterName(Int)

        /// One of the method's parameter types.
        ///
        /// - Parameter index: The index of the parameter.
        case parameterType(Int)

        /// The method's `async`keyword.
        case asyncKeyword

        /// The method's `throws`keyword.
        case throwsKeyword

        /// The method's return type.
        case returnType
    }
}
