
struct ControlSequence: Equatable {
  private let raw: String
}

extension ControlSequence {
  fileprivate var value: String { "\u{1b}[\(raw)" }
}

extension ControlSequence: ExpressibleByStringLiteral {
  init(stringLiteral raw: String) {
    self.init(raw: raw)
  }
}

extension ControlSequence: ExpressibleByStringInterpolation {}

// MARK: - Output

extension TextOutputStream {

  mutating func write(_ control: ControlSequence) {
    write(control.value)
  }
}
