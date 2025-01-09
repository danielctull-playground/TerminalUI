
public struct InfinityInt: Equatable, Hashable, Sendable {
  fileprivate let raw: Raw
  fileprivate enum Raw: Equatable, Hashable, Sendable {
    case infinity
    case value(Int)
  }
}

extension InfinityInt {
  public static let infinity = InfinityInt(raw: .infinity)
}

extension InfinityInt: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(raw: .value(value))
  }
}

extension InfinityInt: Strideable {
  public func distance(to other: InfinityInt) -> Int {
    switch (raw, other.raw) {
    case let (.value(us), .value(other)): us.distance(to: other)
    case (.infinity, _), (_, .infinity): fatalError()
    }
  }
  
  public func advanced(by n: Int) -> InfinityInt {
    switch (raw) {
    case let .value(value): InfinityInt(value.advanced(by: n))
    case .infinity: fatalError()
    }
  }
}

extension InfinityInt: AdditiveArithmetic {

  public static func + (lhs: InfinityInt, rhs: InfinityInt) -> InfinityInt {
    switch (lhs.raw, rhs.raw) {
    case let (.value(lhs), .value(rhs)): InfinityInt(lhs + rhs)
    case (.infinity, _), (_, .infinity): fatalError()
    }
  }

  public static func - (lhs: InfinityInt, rhs: InfinityInt) -> InfinityInt {
    switch (lhs.raw, rhs.raw) {
    case let (.value(lhs), .value(rhs)): InfinityInt(lhs - rhs)
    case (.infinity, _), (_, .infinity): fatalError()
    }
  }
}

extension InfinityInt: FixedWidthInteger {
  public static var bitWidth: Int {
    fatalError()
  }
  
  public static var max: InfinityInt {
    fatalError()
  }
  
  public static var min: InfinityInt {
    fatalError()
  }
  
  public func addingReportingOverflow(_ rhs: InfinityInt) -> (partialValue: InfinityInt, overflow: Bool) {
    fatalError()
  }
  
  public func subtractingReportingOverflow(_ rhs: InfinityInt) -> (partialValue: InfinityInt, overflow: Bool) {
    fatalError()
  }
  
  public func multipliedReportingOverflow(by rhs: InfinityInt) -> (partialValue: InfinityInt, overflow: Bool) {
    fatalError()
  }
  
  public func dividedReportingOverflow(by rhs: InfinityInt) -> (partialValue: InfinityInt, overflow: Bool) {
    fatalError()
  }
  
  public func remainderReportingOverflow(dividingBy rhs: InfinityInt) -> (partialValue: InfinityInt, overflow: Bool) {
    fatalError()
  }
  
  public func dividingFullWidth(_ dividend: (high: InfinityInt, low: Int.Magnitude)) -> (quotient: InfinityInt, remainder: InfinityInt) {
    fatalError()
  }
  
  public var nonzeroBitCount: Int {
    fatalError()
  }
  
  public var leadingZeroBitCount: Int {
    fatalError()
  }
  
  public var byteSwapped: InfinityInt {
    fatalError()
  }
  

}


extension InfinityInt: BinaryInteger {

  
  public static func >>= <RHS>(lhs: inout InfinityInt, rhs: RHS) where RHS : BinaryInteger {
    fatalError()
  }
  
  public static prefix func ~ (x: InfinityInt) -> InfinityInt {
    fatalError()
  }
  
  public static func /= (lhs: inout InfinityInt, rhs: InfinityInt) {
    fatalError()
  }
  
  public static func *= (lhs: inout InfinityInt, rhs: InfinityInt) {
    fatalError()
  }
  
  public init<T>(_ source: T) where T : BinaryInteger {
    self.init(raw: .value(Int(source)))
  }
  
  public init<T>(_truncatingBits source: T) where T : BinaryInteger {
    self.init(raw: .value(Int(_truncatingBits: UInt(source))))
  }

  public init?<T>(exactly source: T) where T : BinaryInteger {
    guard let value = Int(exactly: source) else { return nil }
    self.init(raw: .value(value))
  }

  public var words: Int.Words {
    switch (raw) {
    case let .value(value): value.words
    case .infinity: fatalError()
    }
  }
  
  public init<T>(clamping source: T) where T : BinaryInteger {
    self.init(raw: .value(Int(clamping: source)))
  }
  
  public var magnitude: Int.Magnitude {
    switch (raw) {
    case let .value(value): value.magnitude
    case .infinity: fatalError()
    }
  }
  

  public init?<T>(exactly source: T) where T : BinaryFloatingPoint {
    guard let value = Int(exactly: source) else { return nil }
    self.init(value)
  }

  public init<T>(_ source: T) where T : BinaryFloatingPoint {
    self.init(Int(source))
  }

  public typealias Words = Int.Words

  public static var isSigned: Bool {
    Int.isSigned
  }

  public var bitWidth: Int {
    switch (raw) {
    case let .value(value): value.bitWidth
    case .infinity: fatalError()
    }
  }

  public var trailingZeroBitCount: Int {
    switch (raw) {
    case let .value(value): value.trailingZeroBitCount
    case .infinity: fatalError()
    }
  }

  public static func / (lhs: InfinityInt, rhs: InfinityInt) -> InfinityInt {
    switch (lhs.raw, rhs.raw) {
    case let (.value(lhs), .value(rhs)): InfinityInt(lhs / rhs)
    case (.infinity, _), (_, .infinity): fatalError()
    }
  }

  public static func % (lhs: InfinityInt, rhs: InfinityInt) -> InfinityInt {
    switch (lhs.raw, rhs.raw) {
    case let (.value(lhs), .value(rhs)): InfinityInt(lhs % rhs)
    case (.infinity, _), (_, .infinity): fatalError()
    }
  }

  public static func %= (lhs: inout InfinityInt, rhs: InfinityInt) {
    switch (lhs.raw, rhs.raw) {
    case let (.value(l), .value(r)): lhs = InfinityInt(lhs - rhs)
    case (.infinity, _), (_, .infinity): fatalError()
    }
  }

  public static func * (lhs: InfinityInt, rhs: InfinityInt) -> InfinityInt {
    switch (lhs.raw, rhs.raw) {
    case let (.value(lhs), .value(rhs)): InfinityInt(lhs * rhs)
    case (.infinity, _), (_, .infinity): fatalError()
    }
  }

  public static func &= (lhs: inout InfinityInt, rhs: InfinityInt) {
    fatalError()
  }

  public static func |= (lhs: inout InfinityInt, rhs: InfinityInt) {
    fatalError()
  }

  public static func ^= (lhs: inout InfinityInt, rhs: InfinityInt) {
    fatalError()
  }

  public typealias Magnitude = Int.Magnitude


}

extension Int {
  init(_ value: InfinityInt) {
    switch value.raw {
    case .infinity: self = .max
    case .value(let value): self = value
    }
  }
}
