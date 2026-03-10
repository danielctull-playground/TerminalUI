
/// Control Sequence Introducer
struct CSI: Equatable, Hashable, Sendable {

  fileprivate let marker: Marker?
  fileprivate let parameters: Parameters
  fileprivate let command: Command

  init(
    _ command: Command
  ) {
    self.marker = nil
    self.parameters = []
    self.command = command
  }

  init(
    _ marker: Marker,
    _ command: Command
  ) {
    self.marker = marker
    self.parameters = []
    self.command = command
  }

  init(
    _ parameters: Parameters,
    _ command: Command
  ) {
    self.marker = nil
    self.parameters = parameters
    self.command = command
  }

  init(
    _ marker: Marker,
    _ parameters: Parameters,
    _ command: Command
  ) {
    self.marker = marker
    self.parameters = parameters
    self.command = command
  }
}

// MARK: - CSI.Marker

extension CSI {

  struct Marker: Equatable, Hashable, Sendable {
    fileprivate let byte: Byte
  }
}

extension CSI.Marker {
  static let lessThan = CSI.Marker(byte: 0x3C)
  static let equals = CSI.Marker(byte: 0x3D)
  static let greaterThan = CSI.Marker(byte: 0x3E)
  static let questionMark = CSI.Marker(byte: 0x3F)
}

// MARK: - CSI.Parameters

extension CSI {

  struct Parameters: Equatable, Hashable, Sendable {
    fileprivate let rawValue: [Parameter]
    init(_ parameters: [Parameter]) {
      self.rawValue = parameters
    }
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
    fileprivate let rawValue: Int
    init(_ value: Int) {
      rawValue = value
    }
  }
}

extension CSI.Parameter: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self.init(value)
  }
}


// MARK: - CSI.Command

extension CSI {

  struct Command: Equatable, Hashable, Sendable {
    fileprivate let byte: Byte
  }
}

extension CSI.Command: ExpressibleByUnicodeScalarLiteral {
  public init(unicodeScalarLiteral value: Unicode.Scalar) {
    self.init(byte: Byte(UInt8(ascii: value)))
  }
}

// MARK: - Output

extension TextOutputStream {

  mutating func write(_ csi: CSI) {

    var string = ""

    if let marker = csi.marker {
      string.append(Character(UnicodeScalar(marker.byte.rawValue)))
    }

    string.append(
      csi.parameters.rawValue
        .map(\.rawValue)
        .map(String.init)
        .joined(separator: ";")
    )

    string.append(Character(UnicodeScalar(csi.command.byte.rawValue)))

    write("\u{1b}[\(string)")
  }
}
