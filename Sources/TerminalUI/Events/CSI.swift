
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

// MARK: - CSI.Introducer

extension CSI {

  struct Introducer {}
}

// MARK: - CSI.Marker

extension CSI {

  struct Marker: Equatable, Hashable, Sendable {
    struct Invalid: Error, CustomStringConvertible {
      let byte: Byte
      var description: String { "Invalid CSI.Marker: \(byte)" }
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
    self = precondition(try Self(byte: Byte(UInt8(ascii: value))))
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
    self = [CSI.Intermediate(unicodeScalarLiteral: value)]
  }
}

// MARK: - CSI.Intermediate

extension CSI {

  struct Intermediate: Equatable, Hashable, Sendable {
    struct Invalid: Error, CustomStringConvertible {
      let byte: Byte
      var description: String { "Invalid CSI.Intermediate: \(byte)" }
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
    self = precondition(try Self(byte: Byte(UInt8(ascii: value))))
  }
}

// MARK: - CSI.Command

extension CSI {

  struct Command: Equatable, Hashable, Sendable {
    struct Invalid: Error, CustomStringConvertible {
      let byte: Byte
      var description: String { "Invalid CSI.Command: \(byte)" }
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
    self = precondition(try Self(byte: Byte(UInt8(ascii: value))))
  }
}

// MARK: - Parsing

extension CSI {

  struct TrailingBytes: Error {
    let csi: CSI
    let remainder: ArraySlice<Byte>
  }

  init(_ string: String) throws {
    try self.init(string.utf8.map(Byte.init(_:)))
  }

  init(_ bytes: [Byte]) throws {

    var bytes = Parser(bytes)

    _ = try Introducer(&bytes)
    marker = Marker(&bytes)
    parameters = try Parameters(&bytes)
    intermediates = try Intermediates(&bytes)
    command = try Command(&bytes)

    if let remainder = bytes.remaining {
      throw TrailingBytes(csi: self, remainder: remainder)
    }
  }
}

extension CSI.Introducer {

  struct Missing: Error {}
  struct Invalid: Error, CustomStringConvertible {
    let bytes: [Byte]
    var description: String { "Invalid CSI.Introducer: \(bytes)" }
  }
  fileprivate init(_ bytes: inout Parser<[Byte]>) throws {

    guard let a = bytes.advance(), let b = bytes.advance() else {
      throw Missing()
    }

    guard a == 0x1B, b == 0x5B else {
      throw Invalid(bytes: [a, b])
    }
  }
}

extension CSI.Marker {

  fileprivate init?(_ bytes: inout Parser<[Byte]>) {
    guard let byte = bytes.peek() else { return nil }
    guard let marker = try? CSI.Marker(byte: byte) else { return nil }
    self = marker
    bytes.advance()
  }
}

extension CSI.Parameters {

  fileprivate init(_ bytes: inout Parser<[Byte]>) throws {

    var value: Int?
    var parameters: [CSI.Parameter] = []

    loop: while let byte = bytes.peek() {

      switch byte {
      case (0x30...0x39):
        bytes.advance()
        value = (value ?? 0) * 10 + Int(byte.rawValue - 0x30)
      case 0x3B:
        bytes.advance()
        parameters.append(CSI.Parameter(value ?? 0))
        value = 0
      default:
        break loop
      }
    }

    if let value {
      parameters.append(CSI.Parameter(value))
    }

    self.init(parameters)
  }
}

extension CSI.Intermediates {

  fileprivate init(_ bytes: inout Parser<[Byte]>) throws {
    var intermediates: [CSI.Intermediate] = []
    while let byte = bytes.peek(), let intermediate = try? CSI.Intermediate(byte: byte) {
      intermediates.append(intermediate)
      bytes.advance()
    }
    self.init(intermediates)
  }
}

extension CSI.Command {
  struct Missing: Error {}
  fileprivate init(_ bytes: inout Parser<[Byte]>) throws {
    guard let byte = bytes.advance() else { throw Missing() }
    try self.init(byte: byte)
  }
}

// MARK: - Output

extension TextOutputStream {

  mutating func write(_ csi: CSI) {
    write(csi.description)
  }
}

// MARK: - precondition

/// Checks a necessary condition for making forward progress.
///
/// - Parameter expression: Throwing expression that should not actually throw.
/// - Returns: The result of the expression.
/// - Precondition: The expression must not throw.
private func precondition<T>(_ expression: @autoclosure () throws -> T) -> T {
  do {
    return try expression()
  } catch {
    preconditionFailure("Precondition: \(error)")
  }
}
