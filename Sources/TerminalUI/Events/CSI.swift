
/// Control Sequence Introducer
struct CSI: Equatable, Hashable, Sendable {

  fileprivate let marker: Marker?
  fileprivate let parameters: Parameters
  fileprivate let intermediates: Intermediates
  fileprivate let command: Command

  init(
    marker: Marker? = nil,
    parameters: Parameters = [],
    intermediates: Intermediates = [],
    command: Command
  ) {
    self.marker = marker
    self.parameters = parameters
    self.intermediates = intermediates
    self.command = command
  }
}

extension CSI: CustomStringConvertible {

  var description: String {

    var description = "\u{1b}["

    if let marker = marker {
      description.append(marker.description)
    }

    description.append(parameters.description)
    description.append(intermediates.description)
    description.append(command.description)

    return description
  }
}

// MARK: - CSI.Marker

extension CSI {

  struct Marker: Equatable, Hashable, Sendable {
    private let byte: Byte
    fileprivate init(byte: Byte) {
      precondition((0x3C...0x3F).contains(byte), "Invalid marker: \(byte)")
      self.byte = byte
    }
  }
}

extension CSI.Marker: CustomStringConvertible {
  var description: String {
    String(UnicodeScalar(byte.rawValue))
  }
}

extension CSI.Marker: ExpressibleByUnicodeScalarLiteral {
  init(unicodeScalarLiteral value: Unicode.Scalar) {
    self.init(byte: Byte(UInt8(ascii: value)))
  }
}

// MARK: - CSI.Parameters

extension CSI {

  struct Parameters: Equatable, Hashable, Sendable {
    private let rawValue: [Parameter]
    init(_ parameters: [Parameter]) {
      self.rawValue = parameters
    }
  }
}

extension CSI.Parameters: CustomStringConvertible {
  var description: String {
    rawValue
      .map(\.description)
      .joined(separator: ";")
  }
}

extension CSI.Parameters: ExpressibleByArrayLiteral {
  init(arrayLiteral parameters: CSI.Parameter...) {
    self.init(parameters)
  }
}

extension CSI.Parameters: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self.init([CSI.Parameter(value)])
  }
}

extension CSI.Parameters {
  func appending(_ other: CSI.Parameters) -> CSI.Parameters {
    var parameters = rawValue
    parameters.append(contentsOf: other.rawValue)
    return CSI.Parameters(parameters)
  }
}

// MARK: - CSI.Parameter

extension CSI {

  struct Parameter: Equatable, Hashable, Sendable {
    private let rawValue: Int
    init(_ value: Int) {
      rawValue = value
    }
  }
}

extension CSI.Parameter: CustomStringConvertible {
  var description: String {
    String(rawValue)
  }
}

extension CSI.Parameter: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self.init(value)
  }
}

// MARK: - CSI.Intermediates

extension CSI {

  struct Intermediates: Equatable, Hashable, Sendable {
    private let rawValue: [Intermediate]
    init(_ intermediates: [Intermediate]) {
      self.rawValue = intermediates
    }
  }
}

extension CSI.Intermediates: CustomStringConvertible {
  var description: String {
    rawValue
      .map(\.description)
      .joined()
  }
}

extension CSI.Intermediates: ExpressibleByArrayLiteral {
  init(arrayLiteral intermediates: CSI.Intermediate...) {
    self.init(intermediates)
  }
}

// MARK: - CSI.Intermediate

extension CSI {

  struct Intermediate: Equatable, Hashable, Sendable {
    private let byte: Byte
  }
}

extension CSI.Intermediate: CustomStringConvertible {
  var description: String {
    String(UnicodeScalar(byte.rawValue))
  }
}

extension CSI.Intermediate {
  static let space            = Self(byte: 0x20)
  static let exclamation      = Self(byte: 0x21) // !
  static let quote            = Self(byte: 0x22) // "
  static let hash             = Self(byte: 0x23) // #
  static let dollar           = Self(byte: 0x24) // $
  static let percent          = Self(byte: 0x25) // %
  static let ampersand        = Self(byte: 0x26) // &
  static let apostrophe       = Self(byte: 0x27) // '
  static let leftParenthesis  = Self(byte: 0x28) // (
  static let rightParenthesis = Self(byte: 0x29) // )
  static let asterisk         = Self(byte: 0x2A) // *
  static let plus             = Self(byte: 0x2B) // +
  static let comma            = Self(byte: 0x2C) // ,
  static let hyphen           = Self(byte: 0x2D) // -
  static let period           = Self(byte: 0x2E) // .
  static let slash            = Self(byte: 0x2F) // /
}

// MARK: - CSI.Command

extension CSI {

  struct Command: Equatable, Hashable, Sendable {
    private let byte: Byte
    fileprivate init(byte: Byte) {
      precondition((0x40...0x7E).contains(byte), "Invalid command: \(byte)")
      self.byte = byte
    }
  }
}

extension CSI.Command: CustomStringConvertible {
  var description: String {
    String(UnicodeScalar(byte.rawValue))
  }
}

extension CSI.Command: ExpressibleByUnicodeScalarLiteral {
  init(unicodeScalarLiteral value: Unicode.Scalar) {
    self.init(byte: Byte(UInt8(ascii: value)))
  }
}

// MARK: - Output

extension TextOutputStream {

  mutating func write(_ csi: CSI) {
    write(csi.description)
  }
}
