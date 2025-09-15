import SwiftSyntax
import SwiftSyntaxMacros

public enum EntryMacro: Macro {}

extension EntryMacro: AccessorMacro {

  public static func expansion(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AccessorDeclSyntax] {

    guard context.extendedType == "EnvironmentValues" else {
      throw Failure("Can only be used inside EnvironmentValues.")
    }

    guard let variable = declaration.as(VariableDeclSyntax.self) else {
      throw Failure("Not a variable")
    }

    guard variable.bindings.count == 1 else {
      throw Failure("Can only apply to a single variable")
    }

    let binding = variable.bindings.first!

    guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self) else {
      throw Failure("")
    }

    let name = identifier.identifier.text

    return [
      """
      get {
        self[__Key_\(raw: name).self]
      }
      set {
        self[__Key_\(raw: name).self] = newValue
      }
      """
    ]
  }
}

extension EntryMacro: PeerMacro {

  public static func expansion(
    of node: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {

    guard context.extendedType == "EnvironmentValues" else {
      throw Failure("Can only be used inside EnvironmentValues.")
    }

    guard let variable = declaration.as(VariableDeclSyntax.self) else {
      throw Failure("Not a variable")
    }

    guard variable.bindings.count == 1 else {
      throw Failure("Can only apply to a single variable")
    }

    let binding = variable.bindings.first!

    guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self) else {
      throw Failure("")
    }

    let name = identifier.identifier.text

    guard let initializer = binding.initializer else {
      throw Failure("Must provide a default value.")
    }

    let value = initializer.value

    var type: String
    if let typeAnnotation = binding.typeAnnotation {
      type = typeAnnotation.type.description
    } else {

      guard
        let functionCall = value.as(FunctionCallExprSyntax.self),
        let reference = functionCall.calledExpression.as(DeclReferenceExprSyntax.self)
      else {
        throw Failure("")
      }

      type = reference.baseName.trimmed.text
    }

    return [
      """
      private struct __Key_\(raw: name): EnvironmentKey {
        typealias Value = \(raw: type)
        static var defaultValue: \(raw: type) { 
          \(value) 
        }
      }
      """
    ]
  }
}

extension MacroExpansionContext {

  fileprivate var extendedType: String? {
    lexicalContext
      .lazy
      .compactMap { $0.as(ExtensionDeclSyntax.self) }
      .compactMap { $0.extendedType.as(IdentifierTypeSyntax.self) }
      .compactMap(\.name.text)
      .first
  }
}
