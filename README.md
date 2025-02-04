# swift-mocking

`swift-mocking` is a collection of Swift macros used to generate mock dependencies.

- [Installation](#installation)
- [Usage](#usage)
  - [`@Mocked`](#mocked)
  - [`@MockedMembers`](#mockedmembers)
- [Features](#features)
- [License](#license)

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
It also contains two internal, underscored macros: `@_MockedProperty` and `@_MockedMethod` which are not meant to be used directly.

### `@Mocked`
`@Mocked` is an attached, peer macro that generates a mock class from a protocol declaration.
```swift
@Mocked
protocol Dependency {}

// Generates:

@MockedMembers
final class DependencyMock: Dependency {}
```

The generated mock is marked with the access level required to conform to the protocol:
`public` for `public`, implicit `internal` for both implicit and explicit `internal`,
and `fileprivate` for both `fileprivate` and `private`.

`@Mocked` also supports protocols that conform to `Actor`:
```swift
@Mocked protocol Dependency: Actor {}

// Generates:

@MockedMembers
final actor DependencyMock: Dependency {}
```

When `@Mocked` is applied to a protocol that defines associated types, the resulting mock class 
uses those associated types as its generic parameters in order to fulfill the protocol requirements:
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

In addition to the `@MockedMembers` macro that gets applied to the mock declaration, 
`@Mocked` also utilizes the `@MockableProperty` and `@MockableMethod` macros when defining 
properties required by the mocked protocol:
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
information about each member to `@MockedMembers`. 
`@MockedMembers` then applies the `@_MockedProperty` and `@_MockedMethod` macros to those members, generating 
backing properties that can be used to override those members' implementations.

### `@MockedMembers`
Just like with `@MockedMembers`, `@Mocked` also cannot look outward. This presents a problem when the protocol you 
are trying to mock conforms to another protocol. Because `@Mocked` cannot see the other protocol's declaration, it 
is unable to generate conformances to the requirements from that protocol. In this instance, you will need to write 
the mock declaration yourself, along with the declarations for the properties and methods required by the protocol. 
Then, using `@MockedMembers`, `@MockableProperty`, and `@MockableMethod`, you can generate the mock's backing properties.
```swift
protocol Dependency: SomeProtocol {
    var propertyFromDependency: String { get }
}

@MockedMembers
final class DependencyMock: Dependency {
    @MockableProperty(.readOnly)
    var propertyFromDependency: String

    @MockableProperty(.readWrite)
    var propertyFromSomeProtocol: String
}
```

## Features
`swift-mocking` is Swift 6 compatible, fully concurrency-safe, and generates mocks that can handle:
- [x] Any access level
- [x] Associated types, including primary associated types
- [x] Actor conformance
- [x] Static and instance members
- [x] Read-only properties, including those with getters marked as `async`, `throws`, or `async throws`
- [x] Read-write properties
- [x] Variadic parameters
- [x] Generic methods
- [x] Method overloads
- [ ] Attributed types (`inout`, `consuming`, `sending`, etc.)
- [ ] Typed `throws`

## License

This library is released under the MIT license. See [LICENSE](https://github.com/fetch-rewards/swift-mocking/blob/main/LICENSE) for details.
