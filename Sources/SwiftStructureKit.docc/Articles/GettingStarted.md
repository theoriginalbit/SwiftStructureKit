# Getting Started with SwiftStructureKit

Describe a file and render it.

## Overview

SwiftStructureKit is a library, not a command-line tool. Add it as a package dependency of the executable, build tool plugin, or application that generates Swift source.

Import the library, then describe the file with ``SwiftFile``. Its result builder lets you put declarations directly inside the file and nest members inside types:

<!-- I really wanted to use @TabNavigation but @Tab doesn't respect indentation -->

```swift
import SwiftStructureKit

let file = SwiftFile(imports: [ImportDescriptor("Foundation")]) {
    StructDescriptor(
        "Point",
        accessModifier: .public,
        conformances: [.sendable, .equatable]
    ) {
        PropertyDescriptor.var(
            "x",
            accessModifier: .public,
            type: .double,
            defaultValue: .literal(0.0)
        )
        PropertyDescriptor.var(
            "y",
            accessModifier: .public,
            type: .double,
            defaultValue: .literal(0.0)
        )
    }
}
```

The rendered source is:

```swift
import Foundation

public struct Point: Sendable, Equatable {
    public var x: Double = 0.0

    public var y: Double = 0.0
}
```
