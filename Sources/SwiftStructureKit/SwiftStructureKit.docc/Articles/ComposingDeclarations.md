# Composing Declarations

Build a source file by nesting descriptors that mirror Swift's declaration structure.

## Overview

Descriptors are values that describe source code; they do not compile or execute the code they represent.

A ``SwiftFile`` groups imports and top-level declarations. Types such as ``StructDescriptor`` and ``PlainEnumDescriptor`` then group their own member descriptors.

Result builders are used throughout to make this hierarchy read like the Swift code it generates. For example, a property descriptor can be placed directly in a struct's member builder, and a struct descriptor can be placed directly in the file's declaration builder:

```swift
import SwiftStructureKit

let file = SwiftFile {
    StructDescriptor("Greeting") {
        PropertyDescriptor.let(
            "message",
            type: .string,
            defaultValue: .literal(.string("Hello"))
        )
    }
}
```

This describes the following declaration:

```swift
struct Greeting {
    let message: String = "Hello"
}
```

The builder closures accept descriptors, not arbitrary Swift statements. Use the appropriate descriptor for the construct you need: for example, ``PropertyDescriptor`` for properties, ``FunctionDescriptor`` for functions, and ``StatementDescriptor`` or ``ExpressionDescriptor`` for function bodies and values.

## Choosing Type References and Expressions

Types and values are represented separately. A ``TypeReference`` describes a type such as `String`, while an ``ExpressionDescriptor`` describes a value such as a string literal. Use the provided type and literal conveniences where possible:

```swift
PropertyDescriptor.let(
    "title",
    type: .string,
    defaultValue: .literal(.string("A point"))
)
```

Use ``ExpressionDescriptor/raw(_:)`` **only** when an expression is not represented by a more specific descriptor. Raw source is inserted as supplied, so SwiftStructureKit does not validate or rewrite its syntax.

The library covers declarations, statements, expressions, comments, attributes, and type composition. See the API topics for the descriptor that matches the source construct you want to generate, then use <doc:RenderingSource> to decide where and how to emit the completed file.
