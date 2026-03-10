
/// Control Sequence Introducer
struct CSI: Equatable, Hashable, Sendable {

  fileprivate let marker: Marker?
  fileprivate let parameters: Parameters
  fileprivate let intermediates: Intermediates
  fileprivate let command: Command

  init(
    _ command: Command
  ) {
    self.marker = nil
    self.parameters = []
    self.intermediates = []
    self.command = command
  }

  init(
    _ marker: Marker,
    _ command: Command
  ) {
    self.marker = marker
    self.parameters = []
    self.intermediates = []
    self.command = command
  }

  init(
    _ parameters: Parameters,
    _ command: Command
  ) {
    self.marker = nil
    self.parameters = parameters
    self.intermediates = []
    self.command = command
  }

  init(
    _ intermediates: Intermediates,
    _ command: Command
  ) {
    self.marker = nil
    self.parameters = []
    self.intermediates = intermediates
    self.command = command
  }

  init(
    _ marker: Marker,
    _ parameters: Parameters,
    _ command: Command
  ) {
    self.marker = marker
    self.parameters = parameters
    self.intermediates = []
    self.command = command
  }

  init(
    _ marker: Marker,
    _ intermediates: Intermediates,
    _ command: Command
  ) {
    self.marker = marker
    self.parameters = []
    self.intermediates = intermediates
    self.command = command
  }

  init(
    _ marker: Marker,
    _ parameters: Parameters,
    _ intermediates: Intermediates,
    _ command: Command
  ) {
    self.marker = marker
    self.parameters = parameters
    self.intermediates = intermediates
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

// MARK: - CSI.Intermediates

extension CSI {

  struct Intermediates: Equatable, Hashable, Sendable {
    fileprivate let rawValue: [Intermediate]
    init(_ intermediates: [Intermediate]) {
      self.rawValue = intermediates
    }
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
    fileprivate let byte: Byte
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

    string.append(
      csi.intermediates.rawValue
        .map(\.byte.rawValue)
        .map(UnicodeScalar.init)
        .map(Character.init)
        .map(String.init)
        .joined()
    )

    string.append(Character(UnicodeScalar(csi.command.byte.rawValue)))

    write("\u{1b}[\(string)")
  }
}
