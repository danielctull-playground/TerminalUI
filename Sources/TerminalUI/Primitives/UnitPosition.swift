
/// Normalized point in a view.
public struct UnitPosition: Equatable, Hashable, Sendable {
  public let x: Double
  public let y: Double
  public init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }
}

extension UnitPosition {
  public static let topLeading     = UnitPosition(x: 0,   y: 0)
  public static let top            = UnitPosition(x: 0.5, y: 0)
  public static let topTrailing    = UnitPosition(x: 1,   y: 0)

  public static let leading        = UnitPosition(x: 0,   y: 0.5)
  public static let center         = UnitPosition(x: 0.5, y: 0.5)
  public static let trailing       = UnitPosition(x: 1,   y: 0.5)

  public static let bottomLeading  = UnitPosition(x: 0,   y: 1)
  public static let bottom         = UnitPosition(x: 0.5, y: 1)
  public static let bottomTrailing = UnitPosition(x: 1,   y: 1)
}
