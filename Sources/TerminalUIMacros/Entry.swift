import SwiftSyntax
import SwiftSyntaxMacros

public enum EntryMacro: Macro {}

extension EntryMacro: AccessorMacro {

  public static func expansion(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AccessorDeclSyntax] {

    switch context.extendedType {
    case "EnvironmentValues": try EnvironmentEntry.expansion(providingAccessorsOf: declaration)
    default: throw Failure("Can only be used inside EnvironmentValues.")
    }
  }
}

extension EntryMacro: PeerMacro {

  public static func expansion(
    of node: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {

    switch context.extendedType {
    case "EnvironmentValues": try EnvironmentEntry.expansion(providingPeersOf: declaration)
    default: throw Failure("Can only be used inside EnvironmentValues.")
    }
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
