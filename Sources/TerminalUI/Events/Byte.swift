
struct Byte: Equatable, Hashable, Sendable {
  let rawValue: UInt8
  init(_ rawValue: UInt8) {
    self.rawValue = rawValue
  }
}

extension Byte: Comparable {
  static func < (lhs: Byte, rhs: Byte) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension Byte: CustomStringConvertible {
  var description: String {
    let hex = String(rawValue, radix: 16, uppercase: true)
    let leading = String(repeating: "0", count: max(0, 2 - hex.count))

    return "\"\(Character(Unicode.Scalar(rawValue)))\" (0x" + leading + hex + ")"
  }
}

extension Byte: ExpressibleByIntegerLiteral {
  init(integerLiteral value: UInt8) {
    self.init(value)
  }
}
