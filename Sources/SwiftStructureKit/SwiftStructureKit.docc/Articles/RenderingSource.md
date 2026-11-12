# Rendering Source

Rendering a ``SwiftFile`` descriptor is as easy as calling ``SwiftFile/render(to:indentUsing:)`` to render directly to file, or ``SwiftFile/render(indentUsing:)`` to render in-memory to UTF-8 data (`Data`)

## Write to a File

Use the ``SwiftFile/render(to:indentUsing:)`` function to render and write in one operation. It throws if the data cannot be written to the destination:

```swift
	import Foundation
	import SwiftStructureKit

	let outputURL = URL(fileURLWithPath: "/tmp/Generated.swift")
	try file.render(to: outputURL)
```

The write uses Foundation's atomic file-writing option. Choose a destination appropriate to your generator, and handle any thrown error at the call site.

## Render to Data

Use ``SwiftFile/render(indentUsing:)`` when the generated source should stay in memory, for example when passing it to another tool or testing its contents:

```swift
let data = file.render()
let source = String(decoding: data, as: UTF8.self)
```

The data will always be UTF-8 and can safely converted to a string, with [`String/init(decoding:as:)`](https://developer.apple.com/documentation/swift/string/init(decoding:as:)).

## Indentation

The default indentation is four spaces per level. Pass a ``CodeIndentStyle`` to customise it:

```swift
try file.render(to: outputURL, indentUsing: .tabs)

_ = file.render(indentUsing: .spaces(2))
```
