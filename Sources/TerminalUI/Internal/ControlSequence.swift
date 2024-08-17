
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

// MARK: - Select Graphic Rendition

struct SelectGraphicRendition: Equatable {
  fileprivate let value: Int
}

extension SelectGraphicRendition: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self.init(value: value)
  }
}

extension ControlSequence {

  init(_ sgr: SelectGraphicRendition) {
    self.init("\(sgr.value)m")
  }
}

// MARK: - Output

extension TextOutputStream {

  mutating func write(_ control: ControlSequence) {
    write(control.value)
  }
}
