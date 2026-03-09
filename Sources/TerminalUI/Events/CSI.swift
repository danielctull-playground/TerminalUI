
/// Control Sequence Introducer
struct CSI: Equatable, Sendable {
  fileprivate let raw: String
  fileprivate init(_ raw: String) {
    self.raw = raw
  }
}

extension CSI: ExpressibleByStringLiteral {
  init(stringLiteral raw: String) {
    self.init(raw)
  }
}

extension CSI: ExpressibleByStringInterpolation {}

extension CSI {
  static let clearScreen: CSI = "2J"
}

extension CSI {
  static func alternativeBuffer(_ value: AlternativeBuffer) -> Self {
    value.csi
  }
}

struct AlternativeBuffer {
  fileprivate let csi: CSI
  static let on = AlternativeBuffer(csi: "?1049h")
  static let off = AlternativeBuffer(csi: "?1049l")
}

extension CSI {
  static func cursorVisibility(_ value: CursorVisibility) -> Self {
    value.csi
  }
}

struct CursorVisibility {
  fileprivate let csi: CSI
  static let on = CursorVisibility(csi: "?25h")
  static let off = CursorVisibility(csi: "?25l")
}

// MARK: - GraphicRendition

struct GraphicRendition: Equatable, Hashable {
  fileprivate let values: [Int]
}

extension GraphicRendition: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self.init(values: [value])
  }
}

extension GraphicRendition: ExpressibleByArrayLiteral {
  init(arrayLiteral elements: Int...) {
    self.init(values: elements)
  }
}

extension CSI {

  static func selectGraphicRendition(
    _ rendition: [GraphicRendition]
  ) -> CSI {

    let values = rendition
      .map { $0.values.map(String.init).joined(separator: ";") }
      .joined(separator: ";")

    return CSI("\(values)m")
  }
}

// MARK: - Output

extension TextOutputStream {

  mutating func write(_ csi: CSI) {
    write("\u{1b}[\(csi.raw)")
  }
}
