
// MARK: Horizontal

/// A measurement of the horizontal dimension.
public struct Horizontal: Equatable, Hashable {
  fileprivate let value: Int
}

extension Horizontal: AdditiveArithmetic {
  public static func + (lhs: Horizontal, rhs: Horizontal) -> Horizontal {
    Horizontal(value: lhs.value + rhs.value)
  }

  public static func - (lhs: Horizontal, rhs: Horizontal) -> Horizontal {
    Horizontal(value: lhs.value - rhs.value)
  }
}

extension Horizontal: Comparable {
  public static func < (lhs: Horizontal, rhs: Horizontal) -> Bool {
    lhs.value < rhs.value
  }
}

extension Horizontal: CustomStringConvertible {
  public var description: String {
    value.description
  }
}

extension Horizontal: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(value: value)
  }
}

extension Horizontal: Strideable {
  public func advanced(by n: Int) -> Horizontal {
    Horizontal(value: value.advanced(by: n))
  }

  public func distance(to other: Horizontal) -> Int {
    value.distance(to: other.value)
  }
}

extension Horizontal {
  package init(_ value: some BinaryInteger) {
    self.init(value: Int(value))
  }
}

// MARK: - Vertical

/// A measurement of the vertical dimension.
public struct Vertical: Equatable, Hashable {
  fileprivate let value: Int
}

extension Vertical: AdditiveArithmetic {
  public static func + (lhs: Vertical, rhs: Vertical) -> Vertical {
    Vertical(value: lhs.value + rhs.value)
  }

  public static func - (lhs: Vertical, rhs: Vertical) -> Vertical {
    Vertical(value: lhs.value - rhs.value)
  }
}

extension Vertical: Comparable {
  public static func < (lhs: Vertical, rhs: Vertical) -> Bool {
    lhs.value < rhs.value
  }
}

extension Vertical: CustomStringConvertible {
  public var description: String {
    value.description
  }
}

extension Vertical: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(value: value)
  }
}

extension Vertical: Strideable {
  public func advanced(by n: Int) -> Vertical {
    Vertical(value: value.advanced(by: n))
  }

  public func distance(to other: Vertical) -> Int {
    value.distance(to: other.value)
  }
}

extension Vertical {
  package init(_ value: some BinaryInteger) {
    self.init(value: Int(value))
  }
}
