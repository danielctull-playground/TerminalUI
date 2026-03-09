
struct Byte: Equatable, Hashable, Sendable {
  let rawValue: UInt8
  init(_ rawValue: UInt8) {
    self.rawValue = rawValue
  }
}

extension Byte: ExpressibleByIntegerLiteral {
  init(integerLiteral value: UInt8) {
    self.init(value)
  }
}
