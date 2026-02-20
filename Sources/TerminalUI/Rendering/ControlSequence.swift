
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
  static func mouseTracking(_ value: MouseTracking) -> Self {
    value.control
  }
}

extension ControlSequence {
  static func alternativeBuffer(_ value: AlternativeBuffer) -> Self {
    value.control
  }
}

struct AlternativeBuffer {
  fileprivate let control: ControlSequence
  static let on = AlternativeBuffer(control: "?1049h")
  static let off = AlternativeBuffer(control: "?1049l")
}

extension ControlSequence {
  static func cursorVisibility(_ value: CursorVisibility) -> Self {
    value.control
  }
}

struct CursorVisibility {
  fileprivate let control: ControlSequence
  static let on = CursorVisibility(control: "?25h")
  static let off = CursorVisibility(control: "?25l")
}

struct MouseTracking {
  fileprivate let control: ControlSequence
  static let on = MouseTracking(control: "?1000;1002;1006h")
  static let off = MouseTracking(control: "?1000;1002;1006l")
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

extension ControlSequence {

  static func selectGraphicRendition(
    _ rendition: [GraphicRendition]
  ) -> ControlSequence {

    let values = rendition
      .map { $0.values.map(String.init).joined(separator: ";") }
      .joined(separator: ";")

    return ControlSequence("\(values)m")
  }
}

// MARK: - Output

extension TextOutputStream {

  mutating func write(_ controlSequence: ControlSequence) {
    write("\u{1b}[\(controlSequence.raw)")
  }
}
