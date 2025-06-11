# Swift Mocking's Guide for AI Agents

This file provides comprehensive guidance for AI agents working with this codebase.

## Project Structure

- `/.github`: GitHub-specific workflows, templates, resources, and configurations.
  - `/ISSUE_TEMPLATE`: GitHub issue templates.
  - `/assets`: Assets referenced in GitHub templates and docs.
  - `/scripts`: Scripts used by GitHub workflows.
  - `/workflows`: GitHub workflows used for CI.
- `/Sources`: Source code for Swift Mocking.
  - `/Mocking`: A public library that contains Swift Mocking's macro definitions as well as the types used by generated mocks, all of which create Swift Mocking's public API.
    - `/Extensions`: Internal extensions of existing types (either Swift types or types from imported frameworks).
    - `/Macros`: Public macro definitions.
    - `/Models`: Public types, some of which are used as macro arguments and some of which are used by generated mocks.
      - `/MacroArguments`: Public types used as macro arguments.
      - `/MockImplementationDescription`: A public type that contains information describing a mock implementation.
      - `/MockMethods`: Public types that contain implementation details and invocation records for mock methods.
      - `/MockProperties`: Public types that contain implementation details and invocation records for mock properties.
  - `/MockingClient`: An internal client library for running and testing Swift Mocking's macros. This client library includes a `main.swift` file which is used as a temporary playground for testing Swift Mocking's macro expansions, as well as other files that are used as permanent testing/verification of Swift Mocking's macro expansions in specific scenarios (e.g. method parameters with attributed types, `@Mocked`'s `compilationCondition` argument, generic methods, initializers, method overloads, static members, methods with variadic parameters, etc.).
  - `/MockingMacros`: An internal library that includes a compiler plugin and the implementations of Swift Mocking's macros.
    - `/Extensions`: Internal extensions of existing types (either Swift types or types from imported frameworks).
    - `/Macros`: The implementations of Swift Mocking's macros.
    - `/Models`: Internal types, some of which are used as macro arguments and some of which are used by Swift Mocking's macro implementations.
      - `/MacroArguments`: Internal types used to parse macro arguments. These types mirror those defined in `/Sources/Mocking/Models/MacroArguments`.
      - `/MockMethodNameComponents`: Internal types used to represent the name components of a mock method. These types are used to resolve name conflicts caused by method overloads.

## Coding Conventions

For coding conventions and style guidelines, please read our [Style Guide](/STYLE_GUIDE.md).