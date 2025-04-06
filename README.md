# swift-mocking

`swift-mocking` is a collection of Swift macros used to generate mock dependencies.

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
  - [`@Mocked`](#mocked)
    - [Compilation Condition](#compilation-condition)
    - [Access Levels](#access-levels)
    - [Actor Conformance](#actor-conformance)
    - [Associated Types](#associated-types)
    - [Members](#members)
  - [`@MockedMembers`](#mockedmembers)
    - [Static Members](#static-members)
  - [`@MockableProperty`](#mockableproperty)
  - [`@MockableMethod`](#mockablemethod)
- [License](#license)

## Features
`swift-mocking` is Swift 6 compatible, fully concurrency-safe, and generates conditionally compiled mocks that can handle:
- [x] Any access level
- [x] Associated types, including primary associated types
- [x] Actor conformance
- [x] Generic `where` clauses 
- [x] Initializers
- [x] Static members
- [x] Instance members 
- [x] Read-only properties, including those with getters marked with `async`, `throws`, `mutating`, etc.
- [x] Read-write properties
- [x] Mutating methods
- [x] Async methods
- [x] Throwing methods
- [x] Generic methods
- [x] Method overloads
- [x] Attributed types (`inout`, `consuming`, `sending`, etc.)
- [x] Variadic parameters

## Installation

To add `swift-mocking` to a Swift package manifest file:
- Add the `swift-mocking` package to your package's `dependencies`:
  ```swift
  .package(
      url: "https://github.com/fetch-rewards/swift-mocking.git",
      from: "<#latest swift-mocking tag#>"
  )
  ```
- Add the `Mocked` product to your target's `dependencies`:
  ```swift
  .product(name: "Mocked", package: "swift-mocking")
  ```

## Usage

`swift-mocking` contains several Swift macros: `@Mocked`, `@MockedMembers`, `@MockableProperty`, and `@MockableMethod`. 

It also contains two internal, underscored macros (`@_MockedProperty` and `@_MockedMethod`) which are not meant to be used directly.

### `@Mocked`
`@Mocked` is an attached, peer macro that generates a mock class from a protocol declaration:
```swift
@Mocked
protocol Dependency {}

// Generates:

#if SWIFT_MOCKING_ENABLED
@MockedMembers
final class DependencyMock: Dependency {}
#endif
```

#### Compilation Condition
By default, `@Mocked` wraps the generated mock in an `#if` compiler directive with a `SWIFT_MOCKING_ENABLED`
condition. 

To make use of this condition in an Xcode project, add `SWIFT_MOCKING_ENABLED` as a compiler flag to the build 
configurations for which you would like mocks to compile. 

To make use of this condition in a Swift Package, add the following `SwiftSetting` to your target's `swiftSettings`
array:
```swift
.define("SWIFT_MOCKING_ENABLED", .when(configuration: .debug))
```
> [!Note]
> The `.debug` build configuration in a Swift Package applies to any Xcode project build configuration with a name
> that begins with either "Debug" or "Development".

If you would like to specify a compilation condition other than `SWIFT_MOCKING_ENABLED`, you can explicitly provide
one to the `@Mocked` macro:
```swift
/// The mock will not be wrapped in an `#if` compiler directive.
@Mocked(compilationCondition: .none)
protocol NoneCompilationCondition {}

/// `#if DEBUG`
@Mocked(compilationCondition: .debug)
protocol DebugCompilationCondition {}

/// `#if !RELEASE`
@Mocked(compilationCondition: "!RELEASE")
protocol CustomCompilationCondition {}
```


#### Access Levels
The generated mock is marked with the access level required to conform to the protocol:
`public` for `public`, implicit `internal` for both implicit and explicit `internal`,
and `fileprivate` for both `fileprivate` and `private`.

#### Actor Conformance
`@Mocked` also supports protocols that conform to `Actor`:
```swift
@Mocked
protocol Dependency: Actor {}

// Generates:

@MockedMembers
final actor DependencyMock: Dependency {}
```

#### Associated Types
When `@Mocked` is applied to a protocol that defines associated types, the resulting mock uses 
those associated types as its generic parameters in order to fulfill the protocol requirements:
```swift
@Mocked
protocol Dependency {
    associatedtype Key: Hashable
    associatedtype Value: Equatable
}

// Generates:

@MockedMembers
final class DependencyMock<Key: Hashable, Value: Equatable>: Dependency {}
```

#### Members
In addition to the `@MockedMembers` macro that gets applied to the mock declaration, `@Mocked` also 
utilizes the `@MockableProperty` and `@MockableMethod` macros when defining the mock's members:
```swift
@Mocked
protocol Dependency {
    var readOnlyProperty: String { get }
    var readOnlyAsyncProperty: String { get async }
    var readOnlyThrowingProperty: String { get throws }
    var readOnlyAsyncThrowingProperty: String { get async throws }
    var readWriteProperty: String { get set }
}

// Generates:

@MockedMembers
final class DependencyMock: Dependency {
    @MockableProperty(.readOnly)
    var readOnlyProperty: String

    @MockableProperty(.readOnly(.async))
    var readOnlyAsyncProperty: String

    @MockableProperty(.readOnly(.throws))
    var readOnlyThrowingProperty: String

    @MockableProperty(.readOnly(.async, .throws))
    var readOnlyAsyncThrowingProperty: String

    @MockableProperty(.readWrite)
    var readWriteProperty: String
}
```
Because `@MockedMembers` cannot look outward at the protocol declaration to determine whether, for example,
a property is read-only or read-write, `@Mocked` uses `@MockableProperty` and `@MockableMethod` to provide
information about each member to `@MockedMembers`. `@MockedMembers` then applies the `@_MockedProperty` and 
`@_MockedMethod` macros to those members, generating backing properties that can be used to override those 
members' implementations.

### `@MockedMembers`
Just like with `@MockedMembers`, `@Mocked` also cannot look outward. This presents a problem when the protocol you 
are trying to mock conforms to another protocol. Because `@Mocked` cannot see the other protocol's declaration, it 
is unable to generate conformances to the requirements of that protocol. In this instance, you will need to write 
the mock declaration yourself, along with the declarations for the properties and methods required by the protocols.
Luckily, using Xcode's [Fix-It](https://developer.apple.com/documentation/xcode/fixing-issues-in-your-code-as-you-type#Make-a-Fix-It-correction) 
feature to add protocol conformances and `@MockedMembers`, `@MockableProperty`, and `@MockableMethod` to generate 
backing properties, you can still easily create and maintain these mocks with minimal code.
```swift
protocol Dependency: SomeProtocol {
    var propertyFromDependency: String { get }

    func methodFromDependency()
}

@MockedMembers
final class DependencyMock: Dependency {
    @MockableProperty(.readOnly)
    var propertyFromDependency: String

    @MockableProperty(.readWrite)
    var propertyFromSomeProtocol: String

    func methodFromDependency()

    func methodFromSomeProtocol()
}
```

#### Static Members
When a mock contains static members, `@MockedMembers` generates a static method named `resetMockedStaticMembers`
that can be used to reset the backing properties for those static members:
```swift
@MockedMembers
public final class DependencyMock: Dependency {
    @MockableProperty(.readOnly(.async))
    public static var staticReadOnlyAsyncProperty: Int

    @MockableProperty(.readOnly(.async, .throws))
    public static var staticReadOnlyAsyncThrowingProperty: Int

    @MockableProperty(.readOnly)
    public static var staticReadOnlyProperty: Int

    @MockableProperty(.readOnly(.throws))
    public static var staticReadOnlyThrowingProperty: Int

    @MockableProperty(.readWrite)
    public static var staticReadWriteProperty: Int

    public static func staticReturningAsyncMethodWithoutParameters() async -> Int
    public static func staticReturningAsyncMethodWithParameters(parameter: Int) async -> Int
    public static func staticReturningAsyncThrowingMethodWithoutParameters() async throws -> Int
    public static func staticReturningAsyncThrowingMethodWithParameters(parameter: Int) async throws -> Int
    public static func staticReturningMethodWithoutParameters() -> Int
    public static func staticReturningMethodWithParameters(parameter: Int) -> Int
    public static func staticReturningThrowingMethodWithoutParameters() throws -> Int
    public static func staticReturningThrowingMethodWithParameters(parameter: Int) throws -> Int

    public static func staticVoidAsyncMethodWithoutParameters() async
    public static func staticVoidAsyncMethodWithParameters(parameter: Int) async
    public static func staticVoidAsyncThrowingMethodWithoutParameters() async throws
    public static func staticVoidAsyncThrowingMethodWithParameters(parameter: Int) async throws
    public static func staticVoidMethodWithoutParameters()
    public static func staticVoidMethodWithParameters(parameter: Int)
    public static func staticVoidThrowingMethodWithoutParameters() throws
    public static func staticVoidThrowingMethodWithParameters(parameter: Int) throws

    // Generates:

    /// Resets the implementations and invocation records of the mock's 
    /// static properties and methods.
    public static func resetMockedStaticMembers() {
        self.__staticReadOnlyAsyncProperty.reset()
        self.__staticReadOnlyAsyncThrowingProperty.reset()
        self.__staticReadOnlyProperty.reset()
        self.__staticReadOnlyThrowingProperty.reset()
        self.__staticReadWriteProperty.reset()
        self.__staticReturningAsyncMethodWithoutParameters.reset()
        self.__staticReturningAsyncMethodWithParameters.reset()
        self.__staticReturningAsyncThrowingMethodWithoutParameters.reset()
        self.__staticReturningAsyncThrowingMethodWithParameters.reset()
        self.__staticReturningMethodWithoutParameters.reset()
        self.__staticReturningMethodWithParameters.reset()
        self.__staticReturningThrowingMethodWithoutParameters.reset()
        self.__staticReturningThrowingMethodWithParameters.reset()
        self.__staticVoidAsyncMethodWithoutParameters.reset()
        self.__staticVoidAsyncMethodWithParameters.reset()
        self.__staticVoidAsyncThrowingMethodWithoutParameters.reset()
        self.__staticVoidAsyncThrowingMethodWithParameters.reset()
        self.__staticVoidMethodWithoutParameters.reset()
        self.__staticVoidMethodWithParameters.reset()
        self.__staticVoidThrowingMethodWithoutParameters.reset()
        self.__staticVoidThrowingMethodWithParameters.reset()
    }
}
```
This method is useful for tearing down static state between test cases.

### `@MockableProperty`
In instances where you are using `@MockedMembers` directly instead of using `@Mocked`, `@MockableProperty` 
is required for `@MockedMembers` to be able to generate backing properties for the property conformances 
within your mock:
```swift
protocol Dependency {
    var readOnlyProperty: String { get }
    var readOnlyAsyncProperty: String { get }
    var readOnlyThrowingProperty: String { get }
    var readOnlyAsyncThrowingProperty: String { get }
    var readWriteProperty: String { get set }
}

@MockedMembers
final class DependencyMock: Dependency {
    @MockableProperty(.readOnly)
    var readOnlyProperty: String { get }

    @MockableProperty(.readOnly(.async))
    var readOnlyAsyncProperty: String { get }

    @MockableProperty(.readOnly(.throws))
    var readOnlyThrowingProperty: String { get }

    @MockableProperty(.readOnly(.async, .throws))
    var readOnlyAsyncThrowingProperty: String { get }

    @MockableProperty(.readWrite)
    var readWriteProperty: String { get set }
}
```

### `@MockableMethod`
Unlike `@MockableProperty`, `@MockableMethod` is not required when using `@MockedMembers` directly. 
`@MockedMembers` can and will generate backing properties for method conformances within your mock 
whether they are explicitly marked with `@MockableMethod` or not.

That being said, there may be cases where you want or need to use `@MockableMethod`. While `@Mocked` 
and `@MockedMembers` do an excellent job of dealing with name conflicts caused by method overloads, 
there's always a possibility that a name conflict may arise between two backing properties. In this
case, you can provide an explicit name for the method's backing property using `@MockableMethod`:
```swift
@MockedMembers
final class DependencyMock: Dependency {
    @MockableMethod(mockMethodName: "someUniqueName")
    func methodWithNameConflict()
}
```

In other cases, you may simply dislike the name that `@Mocked` or `@MockedMembers` generates for a 
method's backing property and wish to give the backing property a different name.

If you believe that `@Mocked` or `@MockedMembers` should have been able to resolve a name conflict,
or if you think the name conflict resolution can be improved in any other way, please let us know by
[opening an issue](https://github.com/fetch-rewards/swift-mocking/issues/new).

## License

This library is released under the MIT license. See [LICENSE](https://github.com/fetch-rewards/swift-mocking/blob/main/LICENSE) for details.
