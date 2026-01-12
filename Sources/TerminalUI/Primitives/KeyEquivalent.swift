
/// A keyboard key used to trigger an action.
///
/// Use a key equivalent to describe a specific key on the keyboard. You can use
/// key equivalents when defining keyboard shortcuts for controls.
public struct KeyEquivalent: Equatable, Hashable, Sendable {

  public let character: Character

  /// Creates a key equivalent from a character.
  public init(_ character: Character) {
    self.character = character
  }
}

extension KeyEquivalent: ExpressibleByExtendedGraphemeClusterLiteral {

  public init(extendedGraphemeClusterLiteral value: Character) {
    self.init(value)
  }
}

extension KeyEquivalent {

  /// Up Arrow (U+F700)
  public static let upArrow: Self = KeyEquivalent(Character(UnicodeScalar(0xF700)!))

  /// Down Arrow (U+F701)
  public static let downArrow = KeyEquivalent(Character(UnicodeScalar(0xF701)!))

  /// Left Arrow (U+F702)
  public static let leftArrow = KeyEquivalent(Character(UnicodeScalar(0xF702)!))

  /// Right Arrow (U+F703)
  public static let rightArrow = KeyEquivalent(Character(UnicodeScalar(0xF703)!))

  /// Escape (U+001B)
  public static let escape = KeyEquivalent(Character(UnicodeScalar(0x001B)!))

  /// Delete (U+0008)
  public static let delete = KeyEquivalent(Character(UnicodeScalar(0x0008)!))

  /// Delete Forward (U+F728)
  public static let deleteForward = KeyEquivalent(Character(UnicodeScalar(0xF728)!))

  /// Home (U+F729)
  public static let home = KeyEquivalent(Character(UnicodeScalar(0xF729)!))

  /// End (U+F72B)
  public static let end = KeyEquivalent(Character(UnicodeScalar(0xF72B)!))

  /// Page Up (U+F72C)
  public static let pageUp = KeyEquivalent(Character(UnicodeScalar(0xF72C)!))

  /// Page Down (U+F72D)
  public static let pageDown = KeyEquivalent(Character(UnicodeScalar(0xF72D)!))

  /// Clear (U+F739)
  public static let clear = KeyEquivalent(Character(UnicodeScalar(0xF739)!))

  /// Tab (U+0009)
  public static let tab = KeyEquivalent(Character(UnicodeScalar(0x0009)!))

  /// Space (U+0020)
  public static let space = KeyEquivalent(Character(UnicodeScalar(0x0020)!))

  /// Return (U+000D)
  public static let `return` = KeyEquivalent(Character(UnicodeScalar(0x000D)!))
}
