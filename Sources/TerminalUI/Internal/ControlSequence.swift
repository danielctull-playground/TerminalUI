
struct ControlSequence: Equatable {
  private let raw: String
  fileprivate init(_ raw: String) {
    self.raw = raw
  }
}

extension ControlSequence {
  fileprivate var value: String { "\u{1b}[\(raw)" }
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
  fileprivate let value: Int
}

extension GraphicRendition: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self.init(value: value)
  }
}

extension ControlSequence {
  static func selectGraphicRendition(
    _ rendition: GraphicRendition
  ) -> ControlSequence {
    ControlSequence("\(rendition.value)m")
  }
}

// MARK: - Output

extension TextOutputStream {

  mutating func write(_ control: ControlSequence) {
    write(control.value)
  }
}
