//
//  MockableMethod.swift
//  Mocked
//
//  Created by Gray Campbell on 2/2/25.
//

/// A macro that marks a method as being mockable.
///
/// This macro does not itself produce an expansion and is intended to be used
/// in conjunction with the `@MockedMembers` macro:
/// ```swift
/// @MockedMembers
/// final class DependencyMock: Dependency {
///     @MockableMethod(mockMethodName: "increment")
///     func increment()
/// }
/// ```
///
/// - Important: Use of this macro is not required to generate a mocked method.
///   The ``MockedMembers()`` macro will add the `@_MockedMethod` macro to any
///   method declaration inside its declaration's member block, regardless of
///   whether that method declaration is marked with the
///   ``MockableMethod(mockMethodName:)`` macro. The ``MockedMembers()`` macro
///   is capable of resolving most naming conflicts caused by method overloads,
///   but in cases where it is unable to successfully resolve those conflicts,
///   this macro may be used to provide a unique `mockMethodName` for a method.
/// - Parameter mockMethodName: The name to use for the mock method.
@attached(body)
public macro MockableMethod(mockMethodName: String) = #externalMacro(
    module: "MockedMacros",
    type: "MockableMethodMacro"
)
