
// MARK: Horizontal

/// A measurement of the horizontal dimension.
struct Horizontal: Equatable, Hashable {
  fileprivate let value: Int
}

extension Horizontal: Comparable {
  static func < (lhs: Horizontal, rhs: Horizontal) -> Bool {
    lhs.value < rhs.value
  }
}

extension Horizontal: CustomStringConvertible {
  var description: String {
    value.description
  }
}

extension Horizontal: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self.init(value: value)
  }
}

extension Horizontal: Strideable {
  func advanced(by n: Int) -> Horizontal {
    Horizontal(value: value + n)
  }

  func distance(to other: Horizontal) -> Int {
    value - other.value
  }
}

extension Horizontal {
  init(_ value: some BinaryInteger) {
    self.init(value: Int(value))
  }
}

// MARK: - Vertical

/// A measurement of the vertical dimension.
struct Vertical: Equatable, Hashable {
  fileprivate let value: Int
}

extension Vertical: Comparable {
  static func < (lhs: Vertical, rhs: Vertical) -> Bool {
    lhs.value < rhs.value
  }
}

extension Vertical: CustomStringConvertible {
  var description: String {
    value.description
  }
}

extension Vertical: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self.init(value: value)
  }
}

extension Vertical: Strideable {
  func advanced(by n: Int) -> Vertical {
    Vertical(value: value + n)
  }

  func distance(to other: Vertical) -> Int {
    value - other.value
  }
}

extension Vertical {
  init(_ value: some BinaryInteger) {
    self.init(value: Int(value))
  }
}
