
/// Control Sequence Introducer
struct CSI: Equatable, Hashable, Sendable {

  fileprivate let introducer: Introducer
  fileprivate let marker: Marker?
  fileprivate let parameters: Parameters
  fileprivate let intermediates: Intermediates
  fileprivate let command: Command

  init(
    introducer: Introducer = .escape,
    marker: Marker? = nil,
    parameters: Parameters = [],
    intermediates: Intermediates = [],
    command: Command
  ) {
    self.introducer = introducer
    self.marker = marker
    self.parameters = parameters
    self.intermediates = intermediates
    self.command = command
  }
}

extension CSI: CustomStringConvertible {

  var description: String {
    "CSI \(String(self))"
  }
}

// MARK: - CSI.Introducer

extension CSI {

  struct Introducer: Equatable, Hashable, Sendable {
    private let rawValue: [Byte]
  }
}

extension CSI.Introducer {

  /// The 7-bit escape sequence form: ESC [ (0x1B 0x5B).
  static let escape = CSI.Introducer(rawValue: [0x1B, 0x5B])

  /// The 8-bit compact form: a single CSI byte (0x9B).
  static let compact = CSI.Introducer(rawValue: [0x9B])
}

extension CSI.Introducer: CustomStringConvertible {
  var description: String {
    rawValue.map(\.rawValue)
      .map(Unicode.Scalar.init)
      .map(Character.init)
      .map(String.init)
      .joined()
  }
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

extension CSI: ByteEvent {

  init(parser: inout Parser<[Byte]>) throws {
    introducer = try Introducer(&parser)
    marker = Marker(&parser)
    parameters = try Parameters(&parser)
    intermediates = try Intermediates(&parser)
    command = try Command(&parser)
  }
}

extension CSI.Introducer {

  struct Invalid: Error, CustomStringConvertible {
    let bytes: [Byte]
    var description: String { "Invalid CSI.Introducer: \(bytes)" }
  }
  fileprivate init(_ bytes: inout Parser<[Byte]>) throws {

    let first = try bytes.advance()

    if [first] == CSI.Introducer.compact.rawValue {
      self = .compact
      return
    }

    guard first == CSI.Introducer.escape.rawValue.first else {
      throw Invalid(bytes: [first])
    }

    let second = try bytes.advance()
    guard second == CSI.Introducer.escape.rawValue.last else {
      throw Invalid(bytes: [first, second])
    }

    self = .escape
  }
}

extension CSI.Marker {

  fileprivate init?(_ bytes: inout Parser<[Byte]>) {
    guard let byte = bytes.peek() else { return nil }
    guard let marker = try? CSI.Marker(byte: byte) else { return nil }
    self = marker
    try! bytes.advance()
  }
}

extension CSI.Parameters {

  fileprivate init(_ bytes: inout Parser<[Byte]>) throws {

    var value: Int?
    var parameters: [CSI.Parameter] = []

    loop: while let byte = bytes.peek() {

      switch byte {
      case (0x30...0x39):
        try! bytes.advance()
        value = (value ?? 0) * 10 + Int(byte.rawValue - 0x30)
      case 0x3B:
        try! bytes.advance()
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
      try! bytes.advance()
    }
    self.init(intermediates)
  }
}

extension CSI.Command {
  fileprivate init(_ bytes: inout Parser<[Byte]>) throws {
    let byte = try bytes.advance()
    try self.init(byte: byte)
  }
}

// MARK: - Output

extension TextOutputStream {

  mutating func write(_ csi: CSI) {
    write(String(csi))
  }
}

extension String {

  init(_ csi: CSI) {

    var string = ""

    string.append(csi.introducer.description)

    if let marker = csi.marker {
      string.append(marker.description)
    }

    string.append(csi.parameters.description)
    string.append(csi.intermediates.description)
    string.append(csi.command.description)

    self = string
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
