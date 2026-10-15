# SwiftStructureKit
A lightweight Swift source code renderer. It provides a clean and declarative approach to defining Swift source code.

## Features
- Generate Swift files containing imports, structs, protocols, enums, functions, properties, and type aliases.
- Describe statements, types, attributes, comments, and other source constructs via a declarative API.
- Choose spaces or tabs for indentation.

## Usage

```swift
import SwiftStructureKit

let file = SwiftFile(headerComment: """
  An example for SwiftStructureKit.
  
  This serves as a simple example to demonstrate the fundamentals
  of the API surface. It does not get much more complex than this.
  There are lots of declarative conveniences for construction 
  of descriptors. 
  """) {
  PlainEnumDescriptor(
    "Namespace",
    comment: """
    Comments are optional.
    
    They support multiline string literals.
    As seen further down, function comments will also collect
    all the comments for parameters for it's DocC.
    """
  ) {} members: {
    StructDescriptor("ActualSpace") {
      PropertyDescriptor.let(
        "message",
        type: .string,
        defaultValue: .literal(.string("Hello, %@!"))
      )

      PropertyDescriptor.computed(
        "heading",
        comment: "The current heading",
        accessModifier: .public,
        type: "Vector2D") {
          StatementDescriptor.return(.raw("Vector2D(x: 1, y: 4)"))
        }

      FunctionDescriptor.initializer(accessModifier: .public)

      FunctionDescriptor.function(
        comment: "Creates a greeting for the specified subject",
        name: "greeting",
        returns: .string,
        parameters: ParametersList {
          Parameter("subject", label: "for", type: .string, comment: "The subject the greeting is being addressed to.")
        }) {
          StatementDescriptor.return(.raw("String(format: message, arguments: [subject])"))
        }
    }
  }
}

try file.render(to: filePath, indentUsing: .spaces(2))
```

The rendered source is:

```swift
//
// An example for SwiftStructureKit.
// 
// This serves as a simple example to demonstrate the fundamentals
// of the API surface. It does not get much more complex than this.
// There are lots of declarative conveniences for construction 
// of descriptors. 
//

/// Comments are optional.
/// 
/// They support multiline string literals.
/// As seen further down, function comments will also collect
/// all the comments for parameters for it's DocC.
enum Namespace {
  struct ActualSpace {
    let message: String = "Hello, %@!"

    /// The current heading
    public var heading: Vector2D {
      return Vector2D(x: 1, y: 4)
    }

    public init() {
    }

    /// Creates a greeting for the specified subject
    ///
    /// - Parameter subject: The subject the greeting is being addressed to.
    func greeting(`for` subject: String) -> String {
      return String(format: message, arguments: [subject])
    }
  }
}
```

> [!NOTE]
> 
> Instead of writing to file you can also use `file.render()` to render to `Data`. If a `String` is required conversion is simple and safe with `String(decoding: renderedFile, as: UTF8.self)`.
