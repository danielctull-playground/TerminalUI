
struct ControlSequence: Equatable, Sendable {
  fileprivate let raw: String
  fileprivate init(_ raw: String) {
    self.raw = raw
  }
}

extension ControlSequence: ExpressibleByStringLiteral {
  init(stringLiteral raw: String) {
    self.init(raw)
  }
}

extension ControlSequence: ExpressibleByStringInterpolation {}

extension ControlSequence {
  static let clearScreen: ControlSequence = "2J"
}

struct AlternativeBuffer {
  let control: ControlSequence
  static let on = AlternativeBuffer(control: "?1049h")
  static let off = AlternativeBuffer(control: "?1049l")
}

struct CursorVisibility {
  let control: ControlSequence
  static let on = CursorVisibility(control: "?25h")
  static let off = CursorVisibility(control: "?25l")
}

// MARK: - GraphicRendition

struct GraphicRendition: Equatable {
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

extension ControlSequence {
  static func selectGraphicRendition(
    _ rendition: GraphicRendition
  ) -> ControlSequence {
    let values = rendition.values.map(String.init).joined(separator: ";")
    return ControlSequence("\(values)m")
  }
}

// MARK: - Output

extension TextOutputStream {

  mutating func write(_ controlSequence: ControlSequence) {
    write("\u{1b}[\(controlSequence.raw)")
  }
}
