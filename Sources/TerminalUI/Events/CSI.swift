
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
    struct Invalid: Error {
      let byte: Byte
    }
    private let byte: Byte
    fileprivate init(byte: Byte) throws {
      guard (0x3C...0x3F).contains(byte) else { throw Invalid(byte: byte) }
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
    try! self.init(byte: Byte(UInt8(ascii: value)))
  }
}

// MARK: - CSI.Parameters

extension CSI {

  struct Parameters: Equatable, Hashable, Sendable {
    let elements: [Parameter]
    init(_ parameters: [Parameter]) {
      self.elements = parameters
    }
  }
}

extension CSI.Parameters: CustomStringConvertible {
  var description: String {
    elements
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

extension CSI.Intermediates: ExpressibleByUnicodeScalarLiteral {
  init(unicodeScalarLiteral value: Unicode.Scalar) {
    try! self.init([CSI.Intermediate(byte: Byte(UInt8(ascii: value)))])
  }
}

// MARK: - CSI.Intermediate

extension CSI {

  struct Intermediate: Equatable, Hashable, Sendable {
    struct Invalid: Error {
      let byte: Byte
    }
    private let byte: Byte
    fileprivate init(byte: Byte) throws {
      guard (0x20...0x2F).contains(byte) else { throw Invalid(byte: byte) }
      self.byte = byte
    }
  }
}

extension CSI.Intermediate: CustomStringConvertible {
  var description: String {
    String(UnicodeScalar(byte.rawValue))
  }
}

extension CSI.Intermediate: ExpressibleByUnicodeScalarLiteral {
  init(unicodeScalarLiteral value: Unicode.Scalar) {
    try! self.init(byte: Byte(UInt8(ascii: value)))
  }
}

// MARK: - CSI.Command

extension CSI {

  struct Command: Equatable, Hashable, Sendable {
    struct Invalid: Error {
      let byte: Byte
    }
    private let byte: Byte
    fileprivate init(byte: Byte) throws {
      guard (0x40...0x7E).contains(byte) else { throw Invalid(byte: byte) }
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
    try! self.init(byte: Byte(UInt8(ascii: value)))
  }
}

// MARK: - Output

extension TextOutputStream {

  mutating func write(_ csi: CSI) {
    write(csi.description)
  }
}
