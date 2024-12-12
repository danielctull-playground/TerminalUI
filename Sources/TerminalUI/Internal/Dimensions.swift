
// MARK: Horizontal

/// A measurement of the horizontal dimension.
struct Horizontal: Equatable, Hashable {
  fileprivate let value: Int
}

extension Horizontal: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self.init(value: value)
  }
}

extension Horizontal: CustomStringConvertible {
  var description: String {
    value.description
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

extension Vertical: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self.init(value: value)
  }
}

extension Vertical: CustomStringConvertible {
  var description: String {
    value.description
  }
}

extension Vertical {
  init(_ value: some BinaryInteger) {
    self.init(value: Int(value))
  }
}
