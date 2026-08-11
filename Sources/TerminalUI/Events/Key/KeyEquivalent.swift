
public struct KeyEquivalent: Equatable, Hashable, Sendable {

  public let character: Character

  public init(_ character: Character) {
    self.character = character
  }
}

extension KeyEquivalent: ExpressibleByUnicodeScalarLiteral {
  public init(unicodeScalarLiteral value: Character) {
    self.init(value)
  }
}

extension KeyEquivalent {
  public static let tab: Self = "\t"
}
