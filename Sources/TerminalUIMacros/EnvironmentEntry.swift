import SwiftSyntax
import SwiftSyntaxMacros

enum EnvironmentEntry {}

extension EnvironmentEntry {

  static func expansion(
    providingAccessorsOf declaration: some DeclSyntaxProtocol
  ) throws -> [AccessorDeclSyntax] {

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

extension EnvironmentEntry {

  static func expansion(
    providingPeersOf declaration: some DeclSyntaxProtocol
  ) throws -> [DeclSyntax] {

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

    } else if value.is(FunctionCallExprSyntax.self) {

      guard
        let functionCall = value.as(FunctionCallExprSyntax.self),
        let reference = functionCall.calledExpression.as(DeclReferenceExprSyntax.self)
      else {
        throw Failure("")
      }

      type = reference.baseName.trimmed.text

    } else {

      guard
        let memberAccess = value.as(MemberAccessExprSyntax.self),
        let base = memberAccess.base
      else {
        throw Failure("")
      }

      type = base.description
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
