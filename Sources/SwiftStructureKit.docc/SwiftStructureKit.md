# ``SwiftStructureKit``

Define your Swift source files with a lightweight and declarative API and render them to a file or in-memory data.

@Metadata {
	@PageImage(
	   purpose: icon,
	   source: "swiftStructureKit-icon",
	   alt: "A technology icon representing the SwiftStructureKit framework.")
	@PageColor(purple)
	@TechnologyRoot()
}

## Overview

SwiftStructureKit is a lightweight Swift source code renderer. You build a tree of *descriptors* that model the declarations of a file, type member, statement, expression, and more then render that tree to a file path on disk, or UTF-8 `Data` that can be converted to a `String`. The renderer in this library takes care of indentation, brace placement, blank lines, keyword escaping, and documentation comment layout/formatting so a generator only has to describe *what* the file should contain.

Take a look at the following example.

<!-- I really wanted to use @TabNavigation but @Tab doesn't respect indentation -->

**Code declaration**

```swift
let file = SwiftFile(imports: [ImportDescriptor("Foundation")]) {
	StructDescriptor("Point", accessModifier: .public, conformances: [.sendable, .equatable]) {
		PropertyDescriptor.var("x", accessModifier: .public, type: .double, defaultValue: .literal(0.0))
		PropertyDescriptor.var("y", accessModifier: .public, type: .double, defaultValue: .literal(0.0))
	}
}
```

**Rendered output**

```swift
import Foundation

public struct Point: Sendable, Equatable {
	public var x: Double = 0.0

	public var y: Double = 0.0
}
```

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:ComposingDeclarations>
- <doc:RenderingSource>
- ``SwiftFile``

### Declarations

- ``StructDescriptor``
- ``ProtocolDescriptor``
- ``ExtensionDescriptor``
- ``PlainEnumDescriptor``
- ``AssociatedValueEnumDescriptor``
- ``RawValueEnumDescriptor``
- ``TypealiasDescriptor``
- ``FunctionDescriptor``
- ``PropertyDescriptor``

### Statements and Expressions

- ``StatementDescriptor``
- ``ExpressionDescriptor``
- ``DeclarationStatementDescriptor``
- ``AssignmentStatementDescriptor``
- ``IfStatementDescriptor``
- ``IfElseStatementDescriptor``
- ``GuardStatementDescriptor``
- ``IfExpressionDescriptor``
- ``IfElseExpressionDescriptor``

### Types and Parameters

- ``TypeReference``
- ``TypeIdentifier``
- ``TypeComposition``
- ``TypeConstraintDescriptor``
- ``GenericParameterDescriptor``
- ``ParametersList``
- ``ArgumentsList``

### Supporting Descriptors

- ``ImportDescriptor``
- ``AttributeDescriptor``
- ``AccessModifierDescriptor``
- ``EffectSpecifiers``
- ``LiteralDescriptor``
- ``DocCommentDescriptor``
- ``FileHeaderCommentDescriptor``
- ``CodeIndentStyle``
