# Swift Style Guide

This style guide has been adapted from Google's [Swift Style Guide](https://google.github.io/swift/) © Google LLC, licensed under the [CC-BY 3.0](https://creativecommons.org/licenses/by/3.0/) license.

Sections that have been added or modified for Swift Mocking's conventions are marked with an asterisk (*).

## Table of Contents

- [Source File Basics](#source-file-basics)
    - [File Names](#file-names)
    - [File Encoding](#file-encoding)
    - [Whitespace Characters](#whitespace-characters)
    - [Special Escape Sequences](#special-escape-sequences)
    - [Invisible Characters and Modifiers](#invisible-characters-and-modifiers)
    - [String Literals](#string-literals)
- [Source File Structure](#source-file-structure)
    - [File Comments](#file-comments)
    - [Import Statements](#import-statements)
    - [Type, Variable, and Function Declarations](#type-variable-and-function-declarations)
    - [Overloaded Declarations](#overloaded-declarations)
    - [Extensions](#extensions)
- [General Formatting](#general-formatting)
    - [Column Limit](#column-limit)
    - [Braces](#braces)
    - [Semicolons](#semicolons)
    - [One Statement Per Line](#one-statement-per-line)
    - [Line-Wrapping](#line-wrapping)
        - [Function Declarations](#function-declarations)
        - [Type and Extension Declarations](#type-and-extension-declarations)
        - [Function Calls](#function-calls)
        - [Control Flow Statements](#control-flow-statements)
        - [Other Expressions](#other-expressions)
    - [Horizontal Whitespace](#horizontal-whitespace)
    - [Horizontal Alignment](#horizontal-alignment)
    - [Vertical Whitespace](#vertical-whitespace)
    - [Parentheses](#parentheses)
- [Formatting Specific Constructs](#formatting-specific-constructs)
    - [Non-Documentation Comments](#non-documentation-comments)
    - [Properties](#properties)
    - [Switch Statements](#switch-statements)
    - [Enum Cases](#enum-cases)
    - [Trailing Closures](#trailing-closures)
    - [Trailing Commas](#trailing-commas)
    - [Numeric Literals](#numeric-literals)
    - [Attributes](#attributes)
- [Naming](#naming)
    - [Apple’s API Style Guidelines](#apples-api-style-guidelines)
    - [Naming Conventions Are Not Access Control](#naming-conventions-are-not-access-control)
    - [Identifiers](#identifiers)
    - [Initializers](#initializers)
    - [Static and Class Properties](#static-and-class-properties)
    - [Global Constants](#global-constants)
    - [Delegate Methods](#delegate-methods)
- [Programming Practices](#programming-practices)
    - [Compiler Warnings](#compiler-warnings)
    - [Initializers](#initializers-1)
    - [Properties](#properties-1)
    - [Types with Shorthand Names](#types-with-shorthand-names)
    - [Optional Types](#optional-types)
    - [Error Types](#error-types)
    - [Force Unwrapping and Force Casts](#force-unwrapping-and-force-casts)
    - [Implicitly Unwrapped Optionals](#implicitly-unwrapped-optionals)
    - [Access Levels](#access-levels)
    - [Nesting and Namespacing](#nesting-and-namespacing)
    - [`guard`s for Early Exits](#guards-for-early-exits)
    - [`for`\-`where` Loops](#for-where-loops)
    - [`fallthrough` in `switch` Statements](#fallthrough-in-switch-statements)
    - [Pattern Matching](#pattern-matching)
    - [Tuple Patterns](#tuple-patterns)
    - [Numeric and String Literals](#numeric-and-string-literals)
    - [Playground Literals](#playground-literals)
    - [Trapping vs. Overflowing Arithmetic](#trapping-vs-overflowing-arithmetic)
    - [Defining New Operators](#defining-new-operators)
    - [Overloading Existing Operators](#overloading-existing-operators)
- [Documentation Comments](#documentation-comments)
    - [General Format](#general-format)
    - [Single-Sentence Summary](#single-sentence-summary)
    - [Parameter, Returns, and Throws Tags](#parameter-returns-and-throws-tags)
    - [Apple’s Markup Format](#apples-markup-format)
    - [Where to Document](#where-to-document)

## Source File Basics

### File Names*

All Swift source files end with the extension `.swift`.

In general, each Swift source file should contain exactly one type. A file can contain more than one type as long as only one of those types is accessible from outside the file and the rest are `private` or `fileprivate`.

The name of a source file best describes the primary entity that it contains. A file that primarily contains a single type has the name of that type. A file that extends an existing type with protocol conformance is named with a combination of the type name and the protocol name, joined with a plus (`+`) sign. A file that contains a nested type is named with a combination of the type name in which the nested type is namespaced and the nested type name, joined with a plus (`+`) sign.

For example:
- A file containing a single type `MyType` is named `MyType.swift`.
- A file containing a type `MyType` and some top-level helper functions is also named `MyType.swift`. (The top-level helpers are not the primary entity.)
- A file containing a single extension to a type `MyType` that adds conformance to a protocol `MyProtocol` is named `MyType+MyProtocol.swift`.
- A file containing a type `MyType` that is nested inside another type `MyOtherType` is named `MyOtherType+MyType.swift`.
- A file containing related declarations that are not otherwise scoped under a common type or namespace (such as a collection of global mathematical functions) can be named descriptively; for example, `Math.swift`.

For more complex situations, exercise your best judgment.

### File Encoding

Source files are encoded in UTF-8.

### Whitespace Characters

Aside from the line terminator, the Unicode horizontal space character (`U+0020`) is the only whitespace character that appears anywhere in a source file. The implications are:

- All other whitespace characters in string and character literals are represented by their corresponding escape sequence.
- Tab characters are not used for indentation.

### Special Escape Sequences

For any character that has a special escape sequence (`\t`, `\n`, `\r`, `\"`, `\'`, `\\`, and `\0`), that sequence is used rather than the equivalent Unicode (e.g., `\u{000a}`) escape sequence.

### Invisible Characters and Modifiers

Invisible characters, such as the zero width space and other control characters that do not affect the graphical representation of a string, are always written as Unicode escape sequences.

Control characters, combining characters, and variation selectors that _do_ affect the graphical representation of a string are not escaped when they are attached to a character or characters that they modify. If such a Unicode scalar is present in isolation or is otherwise not modifying another character in the same string, it is written as a Unicode escape sequence.

The strings below are well-formed because the umlauts and variation selectors associate with neighboring characters in the string. The second example is in fact composed of _five_ Unicode scalars, but they are unescaped because the specific combination is rendered as a single character.

```
let size = "Übergröße"
let shrug = "🤷🏿‍️"
```

In the example below, the umlaut and variation selector are in strings by themselves, so they are escaped.

```
let diaeresis = "\u{0308}"
let skinToneType6 = "\u{1F3FF}"
```

If the umlaut were included in the string literally, it would combine with the preceding quotation mark, impairing readability. Likewise, while most systems may render a standalone skin tone modifier as a block graphic, the example below is still forbidden because it is a modifier that is not modifying a character in the same string.

```
let diaeresis = "̈"
let skinToneType6 = "🏿"
```

### String Literals

Unicode escape sequences (`\u{????}`) and literal code points (for example, `Ü`) outside the 7-bit ASCII range are never mixed in the same string.

More specifically, string literals are either:

- composed of a combination of Unicode code points written literally and/or single character escape sequences (such as `\t`, but _not_`\u{????}`), or
- composed of 7-bit ASCII with any number of Unicode escape sequences and/or other escape sequences.

The following example is correct because `\n` is allowed to be present among other Unicode code points.

```
let size = "Übergröße\n"
```

The following example is allowed because it follows the rules above, but it is _not preferred_ because the text is harder to read and understand compared to the string above.

```
let size = "\u{00DC}bergr\u{00F6}\u{00DF}e\n"
```

The example below is forbidden because it mixes code points outside the 7-bit ASCII range in both literal form and in escaped form.

```
let size = "Übergr\u{00F6}\u{00DF}e\n"
```

> **Aside:** Never make your code less readable simply out of fear that some programs might not handle non-ASCII characters properly. If that should happen, those programs are broken and must be fixed.

## Source File Structure

### File Comments

Comments describing the contents of a source file are optional. They are discouraged for files that contain only a single abstraction (such as a class declaration)—in those cases, the documentation comment on the abstraction itself is sufficient and a file comment is only present if it provides additional useful information. File comments are allowed for files that contain multiple abstractions in order to document that grouping as a whole.

### Import Statements

A source file imports exactly the top-level modules that it needs; nothing more and nothing less. If a source file uses definitions from both `UIKit` and `Foundation`, it imports both explicitly; it does not rely on the fact that some Apple frameworks transitively import others as an implementation detail.

Imports of whole modules are preferred to imports of individual declarations or submodules.

> There are a number of reasons to avoid importing individual members:
> 
> *   There is no automated tooling to resolve/organize imports.
> *   Existing automated tooling (such as Xcode’s migrator) are less likely to work well on code that imports individual members because they are considered corner cases.
> *   The prevailing style in Swift (based on official examples and community code) is to import entire modules.

Imports of individual declarations are permitted when importing the whole module would otherwise pollute the global namespace with top-level definitions (such as C interfaces). Use your best judgment in these situations.

Imports of submodules are permitted if the submodule exports functionality that is not available when importing the top-level module. For example, `UIKit.UIGestureRecognizerSubclass` must be imported explicitly to expose the methods that allow client code to subclass `UIGestureRecognizer`—those are not visible by importing `UIKit` alone.

Import statements are not line-wrapped.

Import statements are the first non-comment tokens in a source file. They are grouped in the following fashion, with the imports in each group ordered lexicographically and with exactly one blank line between each group:

1.  Module/submodule imports not under test
2.  Individual declaration imports (`class`, `enum`, `func`, `struct`, `var`)
3.  Modules imported with `@testable` (only present in test sources)

```
import CoreLocation
import MyThirdPartyModule
import SpriteKit
import UIKit

import func Darwin.C.isatty

@testable import MyModuleUnderTest
```

### Type, Variable, and Function Declarations

In general, most source files contain only one top-level type, especially when the type declaration is large. Exceptions are allowed when it makes sense to include multiple related types in a single file. For example,

*   A class and its delegate protocol may be defined in the same file.
*   A type and its small related helper types may be defined in the same file. This can be useful when using `fileprivate` to restrict certain functionality of the type and/or its helpers to only that file and not the rest of the module.

The order of types, variables, and functions in a source file, and the order of the members of those types, can have a great effect on readability. However, there is no single correct recipe for how to do it; different files and different types may order their contents in different ways.

What is important is that each file and type uses _**some** logical order,_ which its maintainer could explain if asked. For example, new methods are not just habitually added to the end of the type, as that would yield “chronological by date added” ordering, which is not a logical ordering.

When deciding on the logical order of members, it can be helpful for readers and future writers (including yourself) to use `// MARK:` comments to provide descriptions for that grouping. These comments are also interpreted by Xcode and provide bookmarks in the source window’s navigation bar. (Likewise, `// MARK: -`, written with a hyphen before the description, causes Xcode to insert a divider before the menu item.) For example,

```
class MovieRatingViewController: UITableViewController {

  // MARK: - View controller lifecycle methods

  override func viewDidLoad() {
    // ...
  }

  override func viewWillAppear(_ animated: Bool) {
    // ...
  }

  // MARK: - Movie rating manipulation methods

  @objc private func ratingStarWasTapped(_ sender: UIButton?) {
    // ...
  }

  @objc private func criticReviewWasTapped(_ sender: UIButton?) {
    // ...
  }
}
```

### Overloaded Declarations

When a type has multiple initializers or subscripts, or a file/type has multiple functions with the same base name (though perhaps with different argument labels), _and_ when these overloads appear in the same type or extension scope, they appear sequentially with no other code in between.

### Extensions

Extensions can be used to organize functionality of a type across multiple “units.” As with member order, the organizational structure/grouping you choose can have a great effect on readability; you must use _**some** logical organizational structure_ that you could explain to a reviewer if asked.

## General Formatting

### Column Limit

Swift code has a column limit of 100 characters. Except as noted below, any line that would exceed this limit must be line-wrapped as described in [Line-Wrapping](#line-wrapping).

**Exceptions:**

1.  Lines where obeying the column limit is not possible without breaking a meaningful unit of text that should not be broken (for example, a long URL in a comment).
2.  `import` statements.
3.  Code generated by another tool.

### Braces

In general, braces follow Kernighan and Ritchie (K&R) style for non-empty blocks with exceptions for Swift-specific constructs and rules:

*   There **is no** line break before the opening brace (`{`), **unless** required by application of the rules in [Line-Wrapping](#line-wrapping).
    
*   There **is a** line break after the opening brace (`{`), except
    
    *   in closures, where the signature of the closure is placed on the same line as the curly brace, if it fits, and a line break follows the `in` keyword.
    *   where it may be omitted as described in [One Statement Per Line](#one-statement-per-line).
    *   empty blocks may be written as `{}`.
*   There **is a** line break before the closing brace (`}`), except where it may be omitted as described in [One Statement Per Line](#one-statement-per-line), or it completes an empty block.
    
*   There **is a** line break after the closing brace (`}`), **if and only if** that brace terminates a statement or the body of a declaration. For example, an `else` block is written `} else {` with both braces on the same line.
    

### Semicolons

Semicolons (`;`) are **not used**, either to terminate or separate statements.

In other words, the only location where a semicolon may appear is inside a string literal or a comment.

```
func printSum(_ a: Int, _ b: Int) {
  let sum = a + b
  print(sum)
}
```

```
func printSum(_ a: Int, _ b: Int) {
  let sum = a + b;
  print(sum);
}
```

### One Statement Per Line

There is **at most** one statement per line, and each statement is followed by a line break, except when the line ends with a block that also contains zero or one statements.

```
guard let value = value else { return 0 }

defer { file.close() }

switch someEnum {
case .first: return 5
case .second: return 10
case .third: return 20
}

let squares = numbers.map { $0 * $0 }

var someProperty: Int {
  get { return otherObject.property }
  set { otherObject.property = newValue }
}

var someProperty: Int { return otherObject.somethingElse() }

required init?(coder aDecoder: NSCoder) { fatalError("no coder") }
```

Wrapping the body of a single-statement block onto its own line is always allowed. Exercise best judgment when deciding whether to place a conditional statement and its body on the same line. For example, single line conditionals work well for early-return and basic cleanup tasks, but less so when the body contains a function call with significant logic. When in doubt, write it as a multi-line statement.

### Line-Wrapping

> Terminology note: **Line-wrapping** is the activity of dividing code into multiple lines that might otherwise legally occupy a single line.

For the purposes of Google Swift style, many declarations (such as type declarations and function declarations) and other expressions (like function calls) can be partitioned into **breakable** units that are separated by **unbreakable** delimiting token sequences.

As an example, consider the following complex function declaration, which needs to be line-wrapped:

```
public func index<Elements: Collection, Element>(of element: Element, in collection: Elements) -> Elements.Index? where Elements.Element == Element, Element: Equatable {
  // ...
}
```

This declaration is split as follows (scroll horizontally if necessary to see the full example). Unbreakable token sequences are indicated in orange; breakable sequences are indicated in blue.

public func index<Elements: Collection, Element>(of element: Element, in collection: Elements) ->Elements.Index?whereElements.Element == Element, Element: Equatable{ // ... }

1.  The **unbreakable** token sequence up through the open angle bracket (`<`) that begins the generic argument list.
2.  The **breakable** list of generic arguments.
3.  The **unbreakable** token sequence (`>(`) that separates the generic arguments from the formal arguments.
4.  The **breakable** comma-delimited list of formal arguments.
5.  The **unbreakable** token-sequence from the closing parenthesis (`)`) up through the arrow (`->`) that precedes the return type.
6.  The **breakable** return type.
7.  The **unbreakable**`where` keyword that begins the generic constraints list.
8.  The **breakable** comma-delimited list of generic constraints.

Using these concepts, the cardinal rules of Google Swift style for line-wrapping are:

1.  If the entire declaration, statement, or expression fits on one line, then do that.
2.  Comma-delimited lists are only laid out in one direction: horizontally or vertically. In other words, all elements must fit on the same line, or each element must be on its own line. A horizontally-oriented list does not contain any line breaks, even before the first element or after the last element. Except in control flow statements, a vertically-oriented list contains a line break before the first element and after each element.
3.  A continuation line starting with an unbreakable token sequence is indented at the same level as the original line.
4.  A continuation line that is part of a vertically-oriented comma-delimited list is indented exactly +2 from the original line.
5.  When an open curly brace (`{`) follows a line-wrapped declaration or expression, it is on the same line as the final continuation line unless that line is indented at +2 from the original line. In that case, the brace is placed on its own line, to avoid the continuation lines from blending visually with the body of the subsequent block.

````
public func index<Elements: Collection, Element>(
  of element: Element,
  in collection: Elements
) -> Elements.Index?
where
  Elements.Element == Element,
  Element: Equatable
{  // GOOD.
  for current in elements {
    // ...
  }
}
```  ```
public func index<Elements: Collection, Element>(
  of element: Element,
  in collection: Elements
) -> Elements.Index?
where
  Elements.Element == Element,
  Element: Equatable {  // AVOID.
  for current in elements {
    // ...
  }
}
````

For declarations that contain a `where` clause followed by generic constraints, additional rules apply:

1.  If the generic constraint list exceeds the column limit when placed on the same line as the return type, then a line break is first inserted **before** the `where` keyword and the `where` keyword is indented at the same level as the original line.
2.  If the generic constraint list still exceeds the column limit after inserting the line break above, then the constraint list is oriented vertically with a line break after the `where` keyword and a line break after the final constraint.

Concrete examples of this are shown in the relevant subsections below.

This line-wrapping style ensures that the different parts of a declaration are _quickly and easily identifiable to the reader_ by using indentation and line breaks, while also preserving the same indentation level for those parts throughout the file. Specifically, it prevents the zig-zag effect that would be present if the arguments are indented based on opening parentheses, as is common in other languages:

```
public func index<Elements: Collection, Element>(of element: Element,  // AVOID.
                                                 in collection: Elements) -> Elements.Index?
    where Elements.Element == Element, Element: Equatable {
  doSomething()
}
```

#### Function Declarations

_modifiers_ func _name_(_formal arguments_){

_modifiers_ func _name_(_formal arguments_) ->_result_{

_modifiers_ func _name_<\_generic arguments\_>(_formal arguments_) throws ->_result_{

_modifiers_ func _name_<\_generic arguments\_>(_formal arguments_) throws ->_result\_where\_generic constraints_{

Applying the rules above from left to right gives us the following line-wrapping:

```
public func index<Elements: Collection, Element>(
  of element: Element,
  in collection: Elements
) -> Elements.Index? where Elements.Element == Element, Element: Equatable {
  for current in elements {
    // ...
  }
}
```

Function declarations in protocols that are terminated with a closing parenthesis (`)`) may place the parenthesis on the same line as the final argument **or** on its own line.

```
public protocol ContrivedExampleDelegate {
  func contrivedExample(
    _ contrivedExample: ContrivedExample,
    willDoSomethingTo someValue: SomeValue)
}

public protocol ContrivedExampleDelegate {
  func contrivedExample(
    _ contrivedExample: ContrivedExample,
    willDoSomethingTo someValue: SomeValue
  )
}
```

If types are complex and/or deeply nested, individual elements in the arguments/constraints lists and/or the return type may also need to be wrapped. In these rare cases, the same line-wrapping rules apply to those parts as apply to the declaration itself.

```
public func performanceTrackingIndex<Elements: Collection, Element>(
  of element: Element,
  in collection: Elements
) -> (
  Element.Index?,
  PerformanceTrackingIndexStatistics.Timings,
  PerformanceTrackingIndexStatistics.SpaceUsed
) {
  // ...
}
```

However, `typealias`es or some other means are often a better way to simplify complex declarations whenever possible.

#### Type and Extension Declarations

The examples below apply equally to `class`, `struct`, `enum`, `extension`, and `protocol` (with the obvious exception that all but the first do not have superclasses in their inheritance list, but they are otherwise structurally similar).

_modifiers_ class _Name_{

_modifiers_ class _Name_:_superclass and protocols_{

_modifiers_ class _Name_<\_generic arguments\_>:_superclass and protocols_{

_modifiers_ class _Name_<\_generic arguments\_>:_superclass and protocols\_where\_generic constraints_{

```
class MyClass:
  MySuperclass,
  MyProtocol,
  SomeoneElsesProtocol,
  SomeFrameworkProtocol
{
  // ...
}

class MyContainer<Element>:
  MyContainerSuperclass,
  MyContainerProtocol,
  SomeoneElsesContainerProtocol,
  SomeFrameworkContainerProtocol
{
  // ...
}

class MyContainer<BaseCollection>:
  MyContainerSuperclass,
  MyContainerProtocol,
  SomeoneElsesContainerProtocol,
  SomeFrameworkContainerProtocol
where BaseCollection: Collection {
  // ...
}

class MyContainer<BaseCollection>:
  MyContainerSuperclass,
  MyContainerProtocol,
  SomeoneElsesContainerProtocol,
  SomeFrameworkContainerProtocol
where
  BaseCollection: Collection,
  BaseCollection.Element: Equatable,
  BaseCollection.Element: SomeOtherProtocolOnlyUsedToForceLineWrapping
{
  // ...
}
```

#### Function Calls

When a function call is line-wrapped, each argument is written on its own line, indented +2 from the original line.

As with function declarations, if the function call terminates its enclosing statement and ends with a closing parenthesis (`)`) (that is, it has no trailing closure), then the parenthesis may be placed **either** on the same line as the final argument **or** on its own line.

```
let index = index(
  of: veryLongElementVariableName,
  in: aCollectionOfElementsThatAlsoHappensToHaveALongName)

let index = index(
  of: veryLongElementVariableName,
  in: aCollectionOfElementsThatAlsoHappensToHaveALongName
)
```

If the function call ends with a trailing closure and the closure’s signature must be wrapped, then place it on its own line and wrap the argument list in parentheses to distinguish it from the body of the closure below it.

```
someAsynchronousAction.execute(withDelay: howManySeconds, context: actionContext) {
  (context, completion) in
  doSomething(withContext: context)
  completion()
}
```

#### Control Flow Statements

When a control flow statement (such as `if`, `guard`, `while`, or `for`) is wrapped, the first continuation line is indented to the same position as the token following the control flow keyword. Additional continuation lines are indented at that same position if they are syntactically parallel elements, or in +2 increments from that position if they are syntactically nested.

The open brace (`{`) preceding the body of the control flow statement can either be placed on the same line as the last continuation line or on the next line, at the same indentation level as the beginning of the statement. For `guard` statements, the `else {` must be kept together, either on the same line or on the next line.

```
if aBooleanValueReturnedByAVeryLongOptionalThing() &&
   aDifferentBooleanValueReturnedByAVeryLongOptionalThing() &&
   yetAnotherBooleanValueThatContributesToTheWrapping() {
  doSomething()
}

if aBooleanValueReturnedByAVeryLongOptionalThing() &&
   aDifferentBooleanValueReturnedByAVeryLongOptionalThing() &&
   yetAnotherBooleanValueThatContributesToTheWrapping()
{
  doSomething()
}

if let value = aValueReturnedByAVeryLongOptionalThing(),
   let value2 = aDifferentValueReturnedByAVeryLongOptionalThing() {
  doSomething()
}

if let value = aValueReturnedByAVeryLongOptionalThing(),
   let value2 = aDifferentValueReturnedByAVeryLongOptionalThingThatForcesTheBraceToBeWrapped()
{
  doSomething()
}

guard let value = aValueReturnedByAVeryLongOptionalThing(),
      let value2 = aDifferentValueReturnedByAVeryLongOptionalThing() else {
  doSomething()
}

guard let value = aValueReturnedByAVeryLongOptionalThing(),
      let value2 = aDifferentValueReturnedByAVeryLongOptionalThing()
else {
  doSomething()
}

for element in collection
    where element.happensToHaveAVeryLongPropertyNameThatYouNeedToCheck {
  doSomething()
}
```

#### Other Expressions

When line-wrapping other expressions that are not function calls (as described above), the second line (the one immediately following the first break) is indented exactly +2 from the original line.

When there are multiple continuation lines, indentation may be varied in increments of +2 as needed. In general, two continuation lines use the same indentation level if and only if they begin with syntactically parallel elements. However, if there are many continuation lines caused by long wrapped expressions, consider splitting them into multiple statements using temporary variables when possible.

```
let result = anExpression + thatIsMadeUpOf * aLargeNumber +
  ofTerms / andTherefore % mustBeWrapped + (
    andWeWill - keepMakingItLonger * soThatWeHave / aContrivedExample)
```

```
let result = anExpression + thatIsMadeUpOf * aLargeNumber +
    ofTerms / andTherefore % mustBeWrapped + (
        andWeWill - keepMakingItLonger * soThatWeHave / aContrivedExample)
```

### Horizontal Whitespace

> **Terminology note:** In this section, _horizontal whitespace_ refers to _interior_ space. These rules are never interpreted as requiring or forbidding additional space at the start of a line.

Beyond where required by the language or other style rules, and apart from literals and comments, a single Unicode space also appears in the following places **only**:

1.  Separating any reserved word starting a conditional or switch statement (such as `if`, `guard`, `while`, or `switch`) from the expression that follows it if that expression starts with an open parenthesis (`(`).

````
if (x == 0 && y == 0) || z == 0 {
  // ...
}
```  ```
if(x == 0 && y == 0) || z == 0 {
  // ...
}
````

2.  Before any closing curly brace (`}`) that follows code on the same line, before any open curly brace (`{`), and after any open curly brace (`{`) that is followed by code on the same line.

````
let nonNegativeCubes = numbers.map { $0 * $0 * $0 }.filter { $0 >= 0 }
```  ```
let nonNegativeCubes = numbers.map { $0 * $0 * $0 } .filter { $0 >= 0 }
let nonNegativeCubes = numbers.map{$0 * $0 * $0}.filter{$0 >= 0}
````

3.  _On both sides_ of any binary or ternary operator, including the “operator-like” symbols described below, with exceptions noted at the end:

```
1.   The `=` sign used in assignment, initialization of variables/properties, and default arguments in functions.
```

````
var x = 5

func sum(_ numbers: [Int], initialValue: Int = 0) {
  // ...
}
```  ```
var x=5

func sum(_ numbers: [Int], initialValue: Int=0) {
  // ...
}
````

```
2.   The ampersand (`&`) in a protocol composition type.
```

````
func sayHappyBirthday(to person: NameProviding & AgeProviding) {
  // ...
}
```  ```
func sayHappyBirthday(to person: NameProviding&AgeProviding) {
  // ...
}
````

```
3.   The operator symbol in a function declaring/implementing that operator.
```

````
static func == (lhs: MyType, rhs: MyType) -> Bool {
  // ...
}
```  ```
static func ==(lhs: MyType, rhs: MyType) -> Bool {
  // ...
}
````

```
4.   The arrow (`->`) preceding the return type of a function.
```

````
func sum(_ numbers: [Int]) -> Int {
  // ...
}
```  ```
func sum(_ numbers: [Int])->Int {
  // ...
}
````

```
5.   **Exception:** There is no space on either side of the dot (`.`) used to reference value and type members.
```

````
let width = view.bounds.width
```  ```
let width = view . bounds . width
````

```
6.   **Exception:** There is no space on either side of the `..<` or `...` operators used in range expressions.
```

````
for number in 1...5 {
  // ...
}

let substring = string[index..<string.endIndex]
```  ```
for number in 1 ... 5 {
  // ...
}

let substring = string[index ..< string.endIndex]
````

4.  After, but not before, the comma (`,`) in parameter lists and in tuple/array/dictionary literals.

````
let numbers = [1, 2, 3]
```  ```
let numbers = [1,2,3]
let numbers = [1 ,2 ,3]
let numbers = [1 , 2 , 3]
````

5.  After, but not before, the colon (`:`) in

```
1.   Superclass/protocol conformance lists and generic constraints.
```

````
struct HashTable: Collection {
  // ...
}

struct AnyEquatable<Wrapped: Equatable>: Equatable {
  // ...
}
```  ```
struct HashTable : Collection {
  // ...
}

struct AnyEquatable<Wrapped : Equatable> : Equatable {
  // ...
}
````

```
2.   Function argument labels and tuple element labels.
```

````
let tuple: (x: Int, y: Int)

func sum(_ numbers: [Int]) {
  // ...
}
```  ```
let tuple: (x:Int, y:Int)
let tuple: (x : Int, y : Int)

func sum(_ numbers:[Int]) {
  // ...
}

func sum(_ numbers : [Int]) {
  // ...
}
````

```
3.   Variable/property declarations with explicit types.
```

````
let number: Int = 5
```  ```
let number:Int = 5
let number : Int = 5
````

```
4.   Shorthand dictionary type names.
```

````
var nameAgeMap: [String: Int] = []
```  ```
var nameAgeMap: [String:Int] = []
var nameAgeMap: [String : Int] = []
````

```
5.   Dictionary literals.
```

````
let nameAgeMap = ["Ed": 40, "Timmy": 9]
```  ```
let nameAgeMap = ["Ed":40, "Timmy":9]
let nameAgeMap = ["Ed" : 40, "Timmy" : 9]
````

6.  At least two spaces before and exactly one space after the double slash (`//`) that begins an end-of-line comment.

````
let initialFactor = 2  // Warm up the modulator.
```  ```
let initialFactor = 2 //    Warm up the modulator.
````

7.  Outside, but not inside, the brackets of an array or dictionary literals and the parentheses of a tuple literal.

````
let numbers = [1, 2, 3]
```  ```
let numbers = [ 1, 2, 3 ]
````

### Horizontal Alignment

> **Terminology note:**_Horizontal alignment_ is the practice of adding a variable number of additional spaces in your code with the goal of making certain tokens appear directly below certain other tokens on previous lines.

Horizontal alignment is forbidden except when writing obviously tabular data where omitting the alignment would be harmful to readability. In other cases (for example, lining up the types of stored property declarations in a `struct` or `class`), horizontal alignment is an invitation for maintenance problems if a new member is introduced that requires every other member to be realigned.

```
struct DataPoint {
  var value: Int
  var primaryColor: UIColor
}
```

```
struct DataPoint {
  var value:        Int
  var primaryColor: UIColor
}
```

### Vertical Whitespace

A single blank line appears in the following locations:

1.  Between consecutive members of a type: properties, initializers, methods, enum cases, and nested types, **except that**:

```
1.   A blank line is optional between two consecutive stored properties or two enum cases whose declarations fit entirely on a single line. Such blank lines can be used to create _logical groupings_ of these declarations.
2.   A blank line is optional between two extremely closely related properties that do not otherwise meet the criterion above; for example, a private stored property and a related public computed property.
```

2.  _Only as needed_ between statements to organize code into logical subsections.
3.  _Optionally_ before the first member or after the last member of a type (neither is encouraged nor discouraged).
4.  Anywhere explicitly required by other sections of this document.

_Multiple_ blank lines are permitted, but never required (nor encouraged). If you do use multiple consecutive blank lines, do so consistently throughout your code base.

### Parentheses

Parentheses are **not** used around the top-most expression that follows an `if`, `guard`, `while`, or `switch` keyword.

```
if x == 0 {
  print("x is zero")
}

if (x == 0 || y == 1) && z == 2 {
  print("...")
}
```

```
if (x == 0) {
  print("x is zero")
}

if ((x == 0 || y == 1) && z == 2) {
  print("...")
}
```

Optional grouping parentheses are omitted only when the author and the reviewer agree that there is no reasonable chance that the code will be misinterpreted without them, nor that they would have made the code easier to read. It is _not_ reasonable to assume that every reader has the entire Swift operator precedence table memorized.

## Formatting Specific Constructs

### Non-Documentation Comments

Non-documentation comments always use the double-slash format (`//`), never the C-style block format (`/* ... */`).

### Properties

Local variables are declared close to the point at which they are first used (within reason) to minimize their scope.

With the exception of tuple destructuring, every `let` or `var` statement (whether a property or a local variable) declares exactly one variable.

```
var a = 5
var b = 10

let (quotient, remainder) = divide(100, 9)
```

```
var a = 5, b = 10
```

### Switch Statements

Case statements are indented at the _same_ level as the switch statement to which they belong; the statements inside the case blocks are then indented +2 spaces from that level.

```
switch order {
case .ascending:
  print("Ascending")
case .descending:
  print("Descending")
case .same:
  print("Same")
}
```

```
switch order {
  case .ascending:
    print("Ascending")
  case .descending:
    print("Descending")
  case .same:
    print("Same")
}
```

```
switch order {
case .ascending:
print("Ascending")
case .descending:
print("Descending")
case .same:
print("Same")
}
```

### Enum Cases

In general, there is only one `case` per line in an `enum`. The comma-delimited form may be used only when none of the cases have associated values or raw values, all cases fit on a single line, and the cases do not need further documentation because their meanings are obvious from their names.

```
public enum Token {
  case comma
  case semicolon
  case identifier
}

public enum Token {
  case comma, semicolon, identifier
}

public enum Token {
  case comma
  case semicolon
  case identifier(String)
}
```

```
public enum Token {
  case comma, semicolon, identifier(String)
}
```

When all cases of an `enum` must be `indirect`, the `enum` itself is declared `indirect` and the keyword is omitted on the individual cases.

```
public indirect enum DependencyGraphNode {
  case userDefined(dependencies: [DependencyGraphNode])
  case synthesized(dependencies: [DependencyGraphNode])
}
```

```
public enum DependencyGraphNode {
  indirect case userDefined(dependencies: [DependencyGraphNode])
  indirect case synthesized(dependencies: [DependencyGraphNode])
}
```

When an `enum` case does not have associated values, empty parentheses are never present.

```
public enum BinaryTree<Element> {
  indirect case node(element: Element, left: BinaryTree, right: BinaryTree)
  case empty  // GOOD.
}
```

```
public enum BinaryTree<Element> {
  indirect case node(element: Element, left: BinaryTree, right: BinaryTree)
  case empty()  // AVOID.
}
```

The cases of an enum must follow a logical ordering that the author could explain if asked. If there is no obviously logical ordering, use a lexicographical ordering based on the cases’ names.

In the following example, the cases are arranged in numerical order based on the underlying HTTP status code and blank lines are used to separate groups.

```
public enum HTTPStatus: Int {
  case ok = 200

  case badRequest = 400
  case notAuthorized = 401
  case paymentRequired = 402
  case forbidden = 403
  case notFound = 404

  case internalServerError = 500
}
```

The following version of the same enum is less readable. Although the cases are ordered lexicographically, the meaningful groupings of related values has been lost.

```
public enum HTTPStatus: Int {
  case badRequest = 400
  case forbidden = 403
  case internalServerError = 500
  case notAuthorized = 401
  case notFound = 404
  case ok = 200
  case paymentRequired = 402
}
```

### Trailing Closures

Functions should not be overloaded such that two overloads differ _only_ by the name of their trailing closure argument. Doing so prevents using trailing closure syntax—when the label is not present, a call to the function with a trailing closure is ambiguous.

Consider the following example, which prohibits using trailing closure syntax to call `greet`:

```
func greet(enthusiastically nameProvider: () -> String) {
  print("Hello, \(nameProvider())! It's a pleasure to see you!")
}

func greet(apathetically nameProvider: () -> String) {
  print("Oh, look. It's \(nameProvider()).")
}

greet { "John" }  // error: ambiguous use of 'greet'
```

This example is fixed by differentiating some part of the function name other than the closure argument—in this case, the base name:

```
func greetEnthusiastically(_ nameProvider: () -> String) {
  print("Hello, \(nameProvider())! It's a pleasure to see you!")
}

func greetApathetically(_ nameProvider: () -> String) {
  print("Oh, look. It's \(nameProvider()).")
}

greetEnthusiastically { "John" }
greetApathetically { "not John" }
```

If a function call has multiple closure arguments, then _none_ are called using trailing closure syntax; _all_ are labeled and nested inside the argument list’s parentheses.

```
UIView.animate(
  withDuration: 0.5,
  animations: {
    // ...
  },
  completion: { finished in
    // ...
  })
```

```
UIView.animate(
  withDuration: 0.5,
  animations: {
    // ...
  }) { finished in
    // ...
  }
```

If a function has a single closure argument and it is the final argument, then it is _always_ called using trailing closure syntax, except in the following cases to resolve ambiguity or parsing errors:

1.  As described above, labeled closure arguments must be used to disambiguate between two overloads with otherwise identical arguments lists.
2.  Labeled closure arguments must be used in control flow statements where the body of the trailing closure would be parsed as the body of the control flow statement.

```
Timer.scheduledTimer(timeInterval: 30, repeats: false) { timer in
  print("Timer done!")
}

if let firstActive = list.first(where: { $0.isActive }) {
  process(firstActive)
}
```

```
Timer.scheduledTimer(timeInterval: 30, repeats: false, block: { timer in
  print("Timer done!")
})

// This example fails to compile.
if let firstActive = list.first { $0.isActive } {
  process(firstActive)
}
```

When a function called with trailing closure syntax takes no other arguments, empty parentheses (`()`) after the function name are _never_ present.

```
let squares = [1, 2, 3].map { $0 * $0 }
```

```
let squares = [1, 2, 3].map({ $0 * $0 })
let squares = [1, 2, 3].map() { $0 * $0 }
```

### Trailing Commas

Trailing commas in array and dictionary literals are _required_ when each element is placed on its own line. Doing so produces cleaner diffs when items are added to those literals later.

```
let configurationKeys = [
  "bufferSize",
  "compression",
  "encoding",                                    // GOOD.
]
```

```
let configurationKeys = [
  "bufferSize",
  "compression",
  "encoding"                                     // AVOID.
]
```

### Numeric Literals

It is recommended but not required that long numeric literals (decimal, hexadecimal, octal, and binary) use the underscore (`_`) separator to group digits for readability when the literal has numeric value or when there exists a domain-specific grouping.

Recommended groupings are three digits for decimal (thousands separators), four digits for hexadecimal, four or eight digits for binary literals, or value-specific field boundaries when they exist (such as three digits for octal file permissions).

Do not group digits if the literal is an opaque identifier that does not have a meaningful numeric value.

### Attributes

Parameterized attributes (such as `@availability(...)` or `@objc(...)`) are each written on their own line immediately before the declaration to which they apply, are lexicographically ordered, and are indented at the same level as the declaration.

```
@available(iOS 9.0, *)
public func coolNewFeature() {
  // ...
}
```

```
@available(iOS 9.0, *) public func coolNewFeature() {
  // ...
}
```

Attributes without parameters (for example, `@objc` without arguments, `@IBOutlet`, or `@NSManaged`) are lexicographically ordered and _may_ be placed on the same line as the declaration if and only if they would fit on that line without requiring the line to be rewrapped. If placing an attribute on the same line as the declaration would require a declaration to be wrapped that previously did not need to be wrapped, then the attribute is placed on its own line.

```
public class MyViewController: UIViewController {
  @IBOutlet private var tableView: UITableView!
}
```

## Naming

### Apple’s API Style Guidelines

Apple’s [official Swift naming and API design guidelines](https://swift.org/documentation/api-design-guidelines/) hosted on swift.org are considered part of this style guide and are followed as if they were repeated here in their entirety.

### Naming Conventions Are Not Access Control

Restricted access control (`internal`, `fileprivate`, or `private`) is preferred for the purposes of hiding information from clients, rather than naming conventions.

Naming conventions (such as prefixing a leading underscore) are only used in rare situations when a declaration must be given higher visibility than is otherwise desired in order to work around language limitations—for example, a type that has a method that is only intended to be called by other parts of a library implementation that crosses module boundaries and must therefore be declared `public`.

### Identifiers

In general, identifiers contain only 7-bit ASCII characters. Unicode identifiers are allowed if they have a clear and legitimate meaning in the problem domain of the code base (for example, Greek letters that represent mathematical concepts) and are well understood by the team who owns the code.

```
let smile = "😊"
let deltaX = newX - previousX
let Δx = newX - previousX
```

```
let 😊 = "😊"
```

### Initializers

For clarity, initializer arguments that correspond directly to a stored property have the same name as the property. Explicit `self.` is used during assignment to disambiguate them.

```
public struct Person {
  public let name: String
  public let phoneNumber: String

  // GOOD.
  public init(name: String, phoneNumber: String) {
    self.name = name
    self.phoneNumber = phoneNumber
  }
}
```

```
public struct Person {
  public let name: String
  public let phoneNumber: String

  // AVOID.
  public init(name otherName: String, phoneNumber otherPhoneNumber: String) {
    name = otherName
    phoneNumber = otherPhoneNumber
  }
}
```

### Static and Class Properties

Static and class properties that return instances of the declaring type are _not_ suffixed with the name of the type.

```
public class UIColor {
  public class var red: UIColor {                // GOOD.
    // ...
  }
}

public class URLSession {
  public class var shared: URLSession {          // GOOD.
    // ...
  }
}
```

```
public class UIColor {
  public class var redColor: UIColor {           // AVOID.
    // ...
  }
}

public class URLSession {
  public class var sharedSession: URLSession {   // AVOID.
    // ...
  }
}
```

When a static or class property evaluates to a singleton instance of the declaring type, the names `shared` and `default` are commonly used. This style guide does not require specific names for these; the author should choose a name that makes sense for the type.

### Global Constants

Like other variables, global constants are `lowerCamelCase`. Hungarian notation, such as a leading `g` or `k`, is not used.

```
let secondsPerMinute = 60
```

```
let SecondsPerMinute = 60
let kSecondsPerMinute = 60
let gSecondsPerMinute = 60
let SECONDS_PER_MINUTE = 60
```

### Delegate Methods

Methods on delegate protocols and delegate-like protocols (such as data sources) are named using the linguistic syntax described below, which is inspired by Cocoa’s protocols.

> The term “delegate’s source object” refers to the object that invokes methods on the delegate. For example, a `UITableView` is the source object that invokes methods on the `UITableViewDelegate` that is set as the view’s `delegate` property.

All methods take the delegate’s source object as the first argument.

For methods that take the delegate’s source object as their **only** argument:

*   If the method returns `Void` (such as those used to notify the delegate that an event has occurred), then the method’s base name is the **delegate’s source type** followed by an **indicative verb phrase** describing the event. The argument is **unlabeled.**

```
func scrollViewDidBeginScrolling(_ scrollView: UIScrollView)
```

*   If the method returns `Bool` (such as those that make an assertion about the delegate’s source object itself), then the method’s name is the **delegate’s source type** followed by an **indicative or conditional verb phrase** describing the assertion. The argument is **unlabeled.**

```
func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool
```

*   If the method returns some other value (such as those querying for information about a property of the delegate’s source object), then the method’s base name is a **noun phrase** describing the property being queried. The argument is **labeled with a preposition or phrase with a trailing preposition** that appropriately combines the noun phrase and the delegate’s source object.

```
func numberOfSections(in scrollView: UIScrollView) -> Int
```

For methods that take **additional** arguments after the delegate’s source object, the method’s base name is the delegate’s source type **by itself** and the first argument is **unlabeled.** Then:

*   If the method returns `Void`, the second argument is **labeled with an indicative verb phrase** describing the event that has the argument as its **direct object or prepositional object,** and any other arguments (if present) provide further context.

```
func tableView(
  _ tableView: UITableView,
  willDisplayCell cell: UITableViewCell,
  forRowAt indexPath: IndexPath)
```

*   If the method returns `Bool`, the second argument is **labeled with an indicative or conditional verb phrase** that describes the return value in terms of the argument, and any other arguments (if present) provide further context.

```
func tableView(
  _ tableView: UITableView,
  shouldSpringLoadRowAt indexPath: IndexPath,
  with context: UISpringLoadedInteractionContext
) -> Bool
```

*   If the method returns some other value, the second argument is **labeled with a noun phrase and trailing preposition** that describes the return value in terms of the argument, and any other arguments (if present) provide further context.

```
func tableView(
  _ tableView: UITableView,
  heightForRowAt indexPath: IndexPath
) -> CGFloat
```

Apple’s documentation on [delegates and data sources](https://developer.apple.com/library/content/documentation/General/Conceptual/CocoaEncyclopedia/DelegatesandDataSources/DelegatesandDataSources.html) also contains some good general guidance about such names.

## Programming Practices

Common themes among the rules in this section are: avoid redundancy, avoid ambiguity, and prefer implicitness over explicitness unless being explicit improves readability and/or reduces ambiguity.

### Compiler Warnings

Code should compile without warnings when feasible. Any warnings that are able to be removed easily by the author must be removed.

A reasonable exception is deprecation warnings, where it may not be possible to immediately migrate to the replacement API, or where an API may be deprecated for external users but must still be supported inside a library during a deprecation period.

### Initializers

For `struct`s, Swift synthesizes a non-public memberwise `init` that takes arguments for `var` properties and for any `let` properties that lack default values. When that initializer is suitable (that is, a `public` one is not needed), it is used and no explicit initializer is written.

The initializers declared by the special `ExpressibleBy*Literal` compiler protocols are never called directly.

```
struct Kilometers: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    // ...
  }
}

let k1: Kilometers = 10                          // GOOD.
let k2 = 10 as Kilometers                        // ALSO GOOD.
```

```
struct Kilometers: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    // ...
  }
}

let k = Kilometers(integerLiteral: 10)           // AVOID.
```

Explicitly calling `.init(...)` is allowed only when the receiver of the call is a metatype variable. In direct calls to the initializer using the literal type name, `.init` is omitted. (**Referring** to the initializer directly by using `MyType.init` syntax to convert it to a closure is permitted.)

```
let x = MyType(arguments)

let type = lookupType(context)
let x = type.init(arguments)

let x = makeValue(factory: MyType.init)
```

```
let x = MyType.init(arguments)
```

### Properties

The `get` block for a read-only computed property is omitted and its body is directly nested inside the property declaration.

```
var totalCost: Int {
  return items.sum { $0.cost }
}
```

```
var totalCost: Int {
  get {
    return items.sum { $0.cost }
  }
}
```

### Types with Shorthand Names

Arrays, dictionaries, and optional types are written in their shorthand form whenever possible; that is, `[Element]`, `[Key: Value]`, and `Wrapped?`. The long forms `Array<Element>`, `Dictionary<Key, Value>`, and `Optional<Wrapped>` are only written when required by the compiler; for example, the Swift parser requires `Array<Element>.Index` and does not accept `[Element].Index`.

```
func enumeratedDictionary<Element>(
  from values: [Element],
  start: Array<Element>.Index? = nil
) -> [Int: Element] {
  // ...
}
```

```
func enumeratedDictionary<Element>(
  from values: Array<Element>,
  start: Optional<Array<Element>.Index> = nil
) -> Dictionary<Int, Element> {
  // ...
}
```

`Void` is a `typealias` for the empty tuple `()`, so from an implementation point of view they are equivalent. In function type declarations (such as closures, or variables holding a function reference), the return type is always written as `Void`, never as `()`. In functions declared with the `func` keyword, the `Void` return type is omitted entirely.

Empty argument lists are always written as `()`, never as `Void`. (In fact, the function signature `Void -> Result` is an error in Swift because function arguments must be surrounded by parentheses, and `(Void)` has a different meaning: an argument list with a single empty-tuple argument.)

```
func doSomething() {
  // ...
}

let callback: () -> Void
```

```
func doSomething() -> Void {
  // ...
}

func doSomething2() -> () {
  // ...
}

let callback: () -> ()
```

### Optional Types

Sentinel values are avoided when designing algorithms (for example, an “index” of −1 when an element was not found in a collection). Sentinel values can easily and accidentally propagate through other layers of logic because the type system cannot distinguish between them and valid outcomes.

`Optional` is used to convey a non-error result that is either a value or the absence of a value. For example, when searching a collection for a value, not finding the value is still a **valid and expected** outcome, not an error.

```
func index(of thing: Thing, in things: [Thing]) -> Int? {
  // ...
}

if let index = index(of: thing, in: lotsOfThings) {
  // Found it.
} else {
  // Didn't find it.
}
```

```
func index(of thing: Thing, in things: [Thing]) -> Int {
  // ...
}

let index = index(of: thing, in: lotsOfThings)
if index != -1 {
  // Found it.
} else {
  // Didn't find it.
}
```

`Optional` is also used for error scenarios when there is a single, obvious failure state; that is, when an operation may fail for a single domain-specific reason that is clear to the client. (The domain-specific restriction is meant to exclude severe errors that are typically out of the user’s control to properly handle, such as out-of-memory errors.)

For example, converting a string to an integer would fail if the string does not represent a valid integer that fits into the type’s bit width:

```
struct Int17 {
  init?(_ string: String) {
    // ...
  }
}
```

Conditional statements that test that an `Optional` is non-`nil` but do not access the wrapped value are written as comparisons to `nil`. The following example is clear about the programmer’s intent:

```
if value != nil {
  print("value was not nil")
}
```

This example, while taking advantage of Swift’s pattern matching and binding syntax, obfuscates the intent by appearing to unwrap the value and then immediately throw it away.

```
if let _ = value {
  print("value was not nil")
}
```

### Error Types

Error types are used when there are multiple possible error states.

Throwing errors instead of merging them with the return type cleanly separates concerns in the API. Valid inputs and valid state produce valid outputs in the result domain and are handled with standard sequential control flow. Invalid inputs and invalid state are treated as errors and are handled using the relevant syntactic constructs (`do`\-`catch` and `try`). For example:

```
struct Document {
  enum ReadError: Error {
    case notFound
    case permissionDenied
    case malformedHeader
  }

  init(path: String) throws {
    // ...
  }
}

do {
  let document = try Document(path: "important.data")
} catch Document.ReadError.notFound {
  // ...
} catch Document.ReadError.permissionDenied {
  // ...
} catch {
  // ...
}
```

Such a design forces the caller to consciously acknowledge the failure case by:

*   wrapping the calling code in a `do`\-`catch` block and handling error cases to whichever degree is appropriate,
*   declaring the function in which the call is made as `throws` and letting the error propagate out, or
*   using `try?` when the specific reason for failure is unimportant and only the information about whether the call failed is needed.

In general, with exceptions noted below, force-`try!` is forbidden; it is equivalent to `try` followed by `fatalError` but without a meaningful message. If an error outcome would mean that the program is in such an unrecoverable state that immediate termination is the only reasonable action, it is better to use `do`\-`catch` or `try?` and provide more context in the error message to assist debugging if the operation does fail.

> **Exception:** Force-`try!` is allowed in unit tests and test-only code. It is also allowed in non-test code when it is unmistakably clear that an error would only be thrown because of **programmer** error; we specifically define this to mean a single expression that could be evaluated without context in the Swift REPL. For example, consider initializing a regular expression from a a string literal:
> 
> ```
> let regex = try! NSRegularExpression(pattern: "a*b+c?")
> ```
> 
> The `NSRegularExpression` initializer throws an error if the regular expression is malformed, but when it is a string literal, the error would only occur if the programmer mistyped it. There is no benefit to writing extra error handling logic here.
> 
> If the pattern above were not a literal but instead were dynamic or derived from user input, `try!` should **not** be used and errors should be handled gracefully.

### Force Unwrapping and Force Casts

Force-unwrapping and force-casting are often code smells and are strongly discouraged. Unless it is extremely clear from surrounding code why such an operation is safe, a comment should be present that describes the invariant that ensures that the operation is safe. For example,

```
let value = getSomeInteger()

// ...intervening code...

// This force-unwrap is safe because `value` is guaranteed to fall within the
// valid enum cases because it came from some data source that only permits
// those raw values.
return SomeEnum(rawValue: value)!
```

> **Exception:** Force-unwraps are allowed in unit tests and test-only code without additional documentation. This keeps such code free of unnecessary control flow. In the event that `nil` is unwrapped or a cast operation is to an incompatible type, the test will fail which is the desired result.

### Implicitly Unwrapped Optionals

Implicitly unwrapped optionals are inherently unsafe and should be avoided whenever possible in favor of non-optional declarations or regular `Optional` types. Exceptions are described below.

User-interface objects whose lifetimes are based on the UI lifecycle instead of being strictly based on the lifetime of the owning object are allowed to use implicitly unwrapped optionals. Examples of these include `@IBOutlet` properties connected to objects in a XIB file or storyboard, properties that are initialized externally like in the `prepareForSegue` implementation of a calling view controller, and properties that are initialized elsewhere during a class’s life cycle, like views in a view controller’s `viewDidLoad` method. Making such properties regular optionals can put too much burden on the user to unwrap them because they are guaranteed to be non-nil and remain that way once the objects are ready for use.

```
class SomeViewController: UIViewController {
  @IBOutlet var button: UIButton!

  override func viewDidLoad() {
    populateLabel(for: button)
  }

  private func populateLabel(for button: UIButton) {
    // ...
  }
}
```

Implicitly unwrapped optionals can also surface in Swift code when using Objective-C APIs that lack the appropriate nullability attributes. If possible, coordinate with the owners of that code to add those annotations so that the APIs are imported cleanly into Swift. If this is not possible, try to keep the footprint of those implicitly unwrapped optionals as small as possible in your Swift code; that is, do not propagate them through multiple layers of your own abstractions.

Implicitly unwrapped optionals are also allowed in unit tests. This is for reasons similar to the UI object scenario above—the lifetime of test fixtures often begins not in the test’s initializer but in the `setUp()` method of a test so that they can be reset before the execution of each test.

### Access Levels

Omitting an explicit access level is permitted on declarations. For top-level declarations, the default access level is `internal`. For nested declarations, the default access level is the lesser of `internal` and the access level of the enclosing declaration.

Specifying an explicit access level at the file level on an extension is forbidden. Each member of the extension has its access level specified if it is different than the default.

```
extension String {
  public var isUppercase: Bool {
    // ...
  }

  public var isLowercase: Bool {
    // ...
  }
}
```

```
public extension String {
  var isUppercase: Bool {
    // ...
  }

  var isLowercase: Bool {
    // ...
  }
}
```

### Nesting and Namespacing

Swift allows `enum`s, `struct`s, and `class`es to be nested, so nesting is preferred (instead of naming conventions) to express scoped and hierarchical relationships among types when possible. For example, flag `enum`s or error types that are associated with a specific type are nested in that type.

```
class Parser {
  enum Error: Swift.Error {
    case invalidToken(String)
    case unexpectedEOF
  }

  func parse(text: String) throws {
    // ...
  }
}
```

```
class Parser {
  func parse(text: String) throws {
    // ...
  }
}

enum ParseError: Error {
  case invalidToken(String)
  case unexpectedEOF
}
```

Swift does not currently allow protocols to be nested in other types or vice versa, so this rule does not apply to situations such as the relationship between a controller class and its delegate protocol.

Declaring an `enum` without cases is the canonical way to define a “namespace” to group a set of related declarations, such as constants or helper functions. This `enum` automatically has no instances and does not require that extra boilerplate code be written to prevent instantiation.

```
enum Dimensions {
  static let tileMargin: CGFloat = 8
  static let tilePadding: CGFloat = 4
  static let tileContentSize: CGSize(width: 80, height: 64)
}
```

```
struct Dimensions {
  private init() {}

  static let tileMargin: CGFloat = 8
  static let tilePadding: CGFloat = 4
  static let tileContentSize: CGSize(width: 80, height: 64)
}
```

### `guard`s for Early Exits

A `guard` statement, compared to an `if` statement with an inverted condition, provides visual emphasis that the condition being tested is a special case that causes early exit from the enclosing scope.

Furthermore, `guard` statements improve readability by eliminating extra levels of nesting (the “pyramid of doom”); failure conditions are closely coupled to the conditions that trigger them and the main logic remains flush left within its scope.

This can be seen in the following examples; in the first, there is a clear progression that checks for invalid states and exits, then executes the main logic in the successful case. In the second example without `guard`, the main logic is buried at an arbitrary nesting level and the thrown errors are separated from their conditions by a great distance.

```
func discombobulate(_ values: [Int]) throws -> Int {
  guard let first = values.first else {
    throw DiscombobulationError.arrayWasEmpty
  }
  guard first >= 0 else {
    throw DiscombobulationError.negativeEnergy
  }

  var result = 0
  for value in values {
    result += invertedCombobulatoryFactory(of: value)
  }
  return result
}
```

```
func discombobulate(_ values: [Int]) throws -> Int {
  if let first = values.first {
    if first >= 0 {
      var result = 0
      for value in values {
        result += invertedCombobulatoryFactor(of: value)
      }
      return result
    } else {
      throw DiscombobulationError.negativeEnergy
    }
  } else {
    throw DiscombobulationError.arrayWasEmpty
  }
}
```

A `guard`\-`continue` statement can also be useful in a loop to avoid increased indentation when the entire body of the loop should only be executed in some cases (but see also the `for`\-`where` discussion below.)

### `for`\-`where` Loops

When the entirety of a `for` loop’s body would be a single `if` block testing a condition of the element, the test is placed in the `where` clause of the `for` statement instead.

```
for item in collection where item.hasProperty {
  // ...
}
```

```
for item in collection {
  if item.hasProperty {
    // ...
  }
}
```

### `fallthrough` in `switch` Statements

When multiple `case`s of a `switch` would execute the same statements, the `case` patterns are combined into ranges or comma-delimited lists. Multiple `case` statements that do nothing but `fallthrough` to a `case` below are not allowed.

```
switch value {
case 1: print("one")
case 2...4: print("two to four")
case 5, 7: print("five or seven")
default: break
}
```

```
switch value {
case 1: print("one")
case 2: fallthrough
case 3: fallthrough
case 4: print("two to four")
case 5: fallthrough
case 7: print("five or seven")
default: break
}
```

In other words, there is never a `case` whose body contains _only_ the `fallthrough` statement. Cases containing _additional_ statements which then fallthrough to the next case are permitted.

### Pattern Matching

The `let` and `var` keywords are placed individually in front of _each_ element in a pattern that is being matched. The shorthand version of `let`/`var` that precedes and distributes across the entire pattern is forbidden because it can introduce unexpected behavior if a value being matched in a pattern is itself a variable.

```
enum DataPoint {
  case unlabeled(Int)
  case labeled(String, Int)
}

let label = "goodbye"

// `label` is treated as a value here because it is not preceded by `let`, so
// the pattern below matches only data points that have the label "goodbye".
switch DataPoint.labeled("hello", 100) {
case .labeled(label, let value):
  // ...
}

// Writing `let` before each individual binding clarifies that the intent is to
// introduce a new binding (shadowing the local variable within the case) rather
// than to match against the value of the local variable. Thus, this pattern
// matches data points with any string label.
switch DataPoint.labeled("hello", 100) {
case .labeled(let label, let value):
  // ...
}
```

In the example below, if the author’s intention was to match using the value of the `label` variable above, that has been lost because `let` distributes across the entire pattern and thus shadows the variable with a binding that applies to any string value:

```
switch DataPoint.labeled("hello", 100) {
case let .labeled(label, value):
  // ...
}
```

Labels of tuple arguments and `enum` associated values are omitted when binding a value to a variable with the same name as the label.

```
enum BinaryTree<Element> {
  indirect case subtree(left: BinaryTree<Element>, right: BinaryTree<Element>)
  case leaf(element: Element)
}

switch treeNode {
case .subtree(let left, let right):
  // ...
case .leaf(let element):
  // ...
}
```

Including the labels adds noise that is redundant and lacking useful information:

```
switch treeNode {
case .subtree(left: let left, right: let right):
  // ...
case .leaf(element: let element):
  // ...
}
```

### Tuple Patterns

Assigning variables through a tuple pattern (sometimes referred to as a _tuple shuffle_) is only permitted if the left-hand side of the assignment is unlabeled.

```
let (a, b) = (y: 4, x: 5.0)
```

```
let (x: a, y: b) = (y: 4, x: 5.0)
```

Labels on the left-hand side closely resemble type annotations, and can lead to confusing code.

```
// This declares two variables, `Int`, which is a `Double` with value 5.0, and
// `Double`, which is an `Int` with value 4.
// `x` and `y` are not variables.
let (x: Int, y: Double) = (y: 4, x: 5.0)
```

### Numeric and String Literals

Integer and string literals in Swift do not have an intrinsic type. For example, `5` by itself is not an `Int`; it is a special literal value that can express any type that conforms to `ExpressibleByIntegerLiteral` and only becomes an `Int` if type inference does not map it to a more specific type. Likewise, the literal `"x"` is neither `String` nor `Character` nor `UnicodeScalar`, but it can become any of those types depending on its context, falling back to `String` as a default.

Thus, when a literal is used to initialize a value of a type other than its default, and when that type cannot be inferred otherwise by context, specify the type explicitly in the declaration or use an `as` expression to coerce it.

```
// Without a more explicit type, x1 will be inferred as type Int.
let x1 = 50

// These are explicitly type Int32.
let x2: Int32 = 50
let x3 = 50 as Int32

// Without a more explicit type, y1 will be inferred as type String.
let y1 = "a"

// These are explicitly type Character.
let y2: Character = "a"
let y3 = "a" as Character

// These are explicitly type UnicodeScalar.
let y4: UnicodeScalar = "a"
let y5 = "a" as UnicodeScalar

func writeByte(_ byte: UInt8) {
  // ...
}
// Inference also occurs for function arguments, so 50 is a UInt8 without
// explicitly coercion.
writeByte(50)
```

The compiler will emit errors appropriately for invalid literal coercions if, for example, a number does not fit into the integer type or a multi-character string is coerced to a character. So while the following examples emit errors, they are “good” because the errors are caught at compile-time and for the right reasons.

```
// error: integer literal '9223372036854775808' overflows when stored into 'Int64'
let a = 0x8000_0000_0000_0000 as Int64

// error: cannot convert value of type 'String' to type 'Character' in coercion
let b = "ab" as Character
```

Using initializer syntax for these types of coercions can lead to misleading compiler errors, or worse, hard-to-debug runtime errors.

```
// This first tries to create an `Int` (signed) from the literal and then
// convert it to a `UInt64`. Even though this literal fits into a `UInt64`, it
// doesn't fit into an `Int` first, so it doesn't compile.
let a1 = UInt64(0x8000_0000_0000_0000)

// This invokes `Character.init(_: String)`, thus creating a `String` "a" at
// runtime (which involves a slow heap allocation), extracting the character
// from it, and then releasing it. This is significantly slower than a proper
// coercion.
let b = Character("a")

// As above, this creates a `String` and then `Character.init(_: String)`
// attempts to extract the single character from it. This fails a precondition
// check and traps at runtime.
let c = Character("ab")
```

### Playground Literals

The graphically-rendered playground literals `#colorLiteral(...)`, `#imageLiteral(...)`, and `#fileLiteral(...)` are forbidden in non-playground production code. They are permitted in playground sources.

```
let color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
```

```
let color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
```

### Trapping vs. Overflowing Arithmetic

The standard (trapping-on-overflow) arithmetic and bitwise operators (`+`, `-`, `*`, `<<`, and `>>`) are used for most normal operations, rather than the masking operations (preceded by `&`). Trapping on overflow is safer because it prevents bad data from propagating through other layers of the system.

```
// GOOD. Overflow will not cause the balance to go negative.
let newBankBalance = oldBankBalance + recentHugeProfit
```

```
// AVOID. Overflow will cause the balance to go negative if the summands are
// large.
let newBankBalance = oldBankBalance &+ recentHugeProfit
```

Masking operations are comparatively rare but are permitted (and in fact necessary for correctness) in problem domains that use modular arithmetic, such as cryptography, big-integer implementations, hash functions, and so forth.

```
var hashValue: Int {
  // GOOD. What matters here is the distribution of the bit pattern rather than
  // the actual numeric value.
  return foo.hashValue &+ 31 * (bar.hashValue &+ 31 &* baz.hashValue)
}
```

```
var hashValue: Int {
  // INCORRECT. This will trap arbitrarily and unpredictably depending on the
  // hash values of the individual terms.
  return foo.hashValue + 31 * (bar.hashValue + 31 * baz.hashValue)
}
```

Masking operations are also permitted in performance-sensitive code where the values are already known to not cause overflow (or where overflow is not a concern). In this case, comments should be used to indicate why the use of masking operations is important. Additionally, consider adding debug preconditions to check these assumptions without affecting performance of optimized builds.

### Defining New Operators

When used unwisely, custom-defined operators can significantly reduce the readability of code because such operators often lack the historical context of the more common ones built into the standard library.

In general, defining custom operators should be avoided. However, it is allowed when an operator has a clear and well-defined meaning in the problem domain and when using an operator significantly improves the readability of the code when compared to function calls. For example, since `*` is the only multiplication operator defined by Swift (not including the masking version), a numeric matrix library may define additional operators to support other operations like cross product and dot product.

An example of a prohibited use case is defining custom `<~~` and `~~>` operators to decode and encode JSON data. Such operators are not native to the problem domain of processing JSON and even an experienced Swift engineer would have difficulty understanding the purpose of the code without seeking out documentation of those operators.

If you must use third-party code of unquestionable value that provides an API only available through custom operators, you are **strongly encouraged** to consider writing a wrapper that defines more readable methods that delegate to the custom operators. This will significantly reduce the learning curve required to understand how such code works for new teammates and other code reviewers.

### Overloading Existing Operators

Overloading operators is permitted when your use of the operator is semantically equivalent to the existing uses in the standard library. Examples of permitted use cases are implementing the operator requirements for `Equatable` and `Hashable`, or defining a new `Matrix` type that supports arithmetic operations.

If you wish to overload an existing operator with a meaning other than its natural meaning, follow the guidance in [Defining New Operators](#defining-new-operators) to determine whether this is permitted. In other words, if the new meaning is well-established in the problem domain and the use of the operator is a readability improvement over other syntactic constructs, then it is permitted.

An example of a prohibited case of operator repurposing would be to overload `*` and `+` to build an ad hoc regular expression API. Such an API would not provide strong enough readability benefits compared to simply representing the entire regular expression as a string.

## Documentation Comments

### General Format

Documentation comments are written using the format where each line is preceded by a triple slash (`///`). Javadoc-style block comments (`/** ... */`) are not permitted.

```
/// Returns the numeric value of the given digit represented as a Unicode scalar.
///
/// - Parameters:
///   - digit: The Unicode scalar whose numeric value should be returned.
///   - radix: The radix, between 2 and 36, used to compute the numeric value.
/// - Returns: The numeric value of the scalar.
func numericValue(of digit: UnicodeScalar, radix: Int = 10) -> Int {
  // ...
}
```

```
/**
 * Returns the numeric value of the given digit represented as a Unicode scalar.
 *
 * - Parameters:
 *   - digit: The Unicode scalar whose numeric value should be returned.
 *   - radix: The radix, between 2 and 36, used to compute the numeric value.
 * - Returns: The numeric value of the scalar.
 */
func numericValue(of digit: UnicodeScalar, radix: Int = 10) -> Int {
  // ...
}

/**
Returns the numeric value of the given digit represented as a Unicode scalar.

- Parameters:
  - digit: The Unicode scalar whose numeric value should be returned.
  - radix: The radix, between 2 and 36, used to compute the numeric value.
- Returns: The numeric value of the scalar.
*/
func numericValue(of digit: UnicodeScalar, radix: Int = 10) -> Int {
  // ...
}
```

### Single-Sentence Summary

Documentation comments begin with a brief **single-sentence** summary that describes the declaration. (This sentence may span multiple lines, but if it spans too many lines, the author should consider whether the summary can be simplified and details moved to a new paragraph.)

If more detail is needed than can be stated in the summary, additional paragraphs (each separated by a blank line) are added after it.

The single-sentence summary is not necessarily a complete sentence; for example, method summaries are generally written as verb phrases **without** “this method \[…\]” because it is already implied as the subject and writing it out would be redundant. Likewise, properties are often written as noun phrases **without** “this property is \[…\]”. In any case, however, they are still terminated with a period.

```
/// The background color of the view.
var backgroundColor: UIColor

/// Returns the sum of the numbers in the given array.
///
/// - Parameter numbers: The numbers to sum.
/// - Returns: The sum of the numbers.
func sum(_ numbers: [Int]) -> Int {
  // ...
}
```

```
/// This property is the background color of the view.
var backgroundColor: UIColor

/// This method returns the sum of the numbers in the given array.
///
/// - Parameter numbers: The numbers to sum.
/// - Returns: The sum of the numbers.
func sum(_ numbers: [Int]) -> Int {
  // ...
}
```

### Parameter, Returns, and Throws Tags

Clearly document the parameters, return value, and thrown errors of functions using the `Parameter(s)`, `Returns`, and `Throws` tags, in that order. None ever appears with an empty description. When a description does not fit on a single line, continuation lines are indented 2 spaces in from the position of the hyphen starting the tag.

The recommended way to write documentation comments in Xcode is to place the text cursor on the declaration and press **Command + Option + /**. This will automatically generate the correct format with placeholders to be filled in.

`Parameter(s)` and `Returns` tags may be omitted only if the single-sentence brief summary fully describes the meaning of those items and including the tags would only repeat what has already been said.

The content following the `Parameter(s)`, `Returns`, and `Throws` tags should be terminated with a period, even when they are phrases instead of complete sentences.

When a method takes a single argument, the singular inline form of the `Parameter` tag is used. When a method takes multiple arguments, the grouped plural form `Parameters` is used and each argument is written as an item in a nested list with only its name as the tag.

```
/// Returns the output generated by executing a command.
///
/// - Parameter command: The command to execute in the shell environment.
/// - Returns: A string containing the contents of the invoked process's
///   standard output.
func execute(command: String) -> String {
  // ...
}

/// Returns the output generated by executing a command with the given string
/// used as standard input.
///
/// - Parameters:
///   - command: The command to execute in the shell environment.
///   - stdin: The string to use as standard input.
/// - Returns: A string containing the contents of the invoked process's
///   standard output.
func execute(command: String, stdin: String) -> String {
  // ...
}
```

The following examples are incorrect, because they use the plural form of `Parameters` for a single parameter or the singular form `Parameter` for multiple parameters.

```
/// Returns the output generated by executing a command.
///
/// - Parameters:
///   - command: The command to execute in the shell environment.
/// - Returns: A string containing the contents of the invoked process's
///   standard output.
func execute(command: String) -> String {
  // ...
}

/// Returns the output generated by executing a command with the given string
/// used as standard input.
///
/// - Parameter command: The command to execute in the shell environment.
/// - Parameter stdin: The string to use as standard input.
/// - Returns: A string containing the contents of the invoked process's
///   standard output.
func execute(command: String, stdin: String) -> String {
  // ...
}
```

### Apple’s Markup Format

Use of [Apple’s markup format](https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_markup_formatting_ref/) is strongly encouraged to add rich formatting to documentation. Such markup helps to differentiate symbolic references (like parameter names) from descriptive text in comments and is rendered by Xcode and other documentation generation tools. Some examples of frequently used directives are listed below.

*   Paragraphs are separated using a single line that starts with `///` and is otherwise blank.
*   __Single asterisks__ and _\_single underscores\__ surround text that should be rendered in italic/oblique type.
*   ****Double asterisks**** and ****double underscores**** surround text that should be rendered in boldface.
*   Names of symbols or inline code are surrounded in `backticks`.
*   Multi-line code (such as example usage) is denoted by placing three backticks (\`\`\`\` \`) on the lines before and after the code block.

### Where to Document

At a minimum, documentation comments are present for every open or public declaration, and every open or public member of such a declaration, with specific exceptions noted below:

*   Individual cases of an `enum` often are not documented if their meaning is self-explanatory from their name. Cases with associated values, however, should document what those values mean if it is not obvious.
    
*   A documentation comment is not always present on a declaration that overrides a supertype declaration or implements a protocol requirement, or on a declaration that provides the default implementation of a protocol requirement in an extension.
    

It is acceptable to document an overridden declaration to describe new behavior from the declaration that it overrides. In no case should the documentation for the override be a mere copy of the base declaration’s documentation.

*   A documentation comment is not always present on test classes and test methods. However, they can be useful for functional test classes and for helper classes/methods shared by multiple tests.
    
*   A documentation comment is not always present on an extension declaration (that is, the `extension` itself). You may choose to add one if it help clarify the purpose of the extension, but avoid meaningless or misleading comments.
    

In the following example, the comment is just repetition of what is already obvious from the source code:

```
/// Add `Equatable` conformance.
extension MyType: Equatable {
  // ...
}
```

The next example is more subtle, but it is an example of documentation that is not scalable because the extension or the conformance could be updated in the future. Consider that the type may be made `Comparable` at the time of that writing in order to sort the values, but that is not the only possible use of that conformance and client code could use it for other purposes in the future.

```
/// Make `Candidate` comparable so that they can be sorted.
extension Candidate: Comparable {
  // ...
}
```

In general, if you find yourself writing documentation that simply repeats information that is obvious from the source and sugaring it with words like “a representation of,” then leave the comment out entirely.

However, it is _not_ appropriate to cite this exception to justify omitting relevant information that a typical reader might need to know. For example, for a property named `canonicalName`, don’t omit its documentation (with the rationale that it would only say `/// The canonical name.`) if a typical reader may have no idea what the term “canonical name” means in that context. Use the documentation as an opportunity to define the term.