
struct ControlSequence: Equatable {
  private let raw: String
}

extension ControlSequence {
  var value: String { "\u{1b}[\(raw)" }
}

extension ControlSequence: ExpressibleByStringLiteral {
  init(stringLiteral raw: String) {
    self.init(raw: raw)
  }
}

extension ControlSequence: ExpressibleByStringInterpolation {}
