
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

extension GraphicRendition: Comparable {

  static func < (lhs: GraphicRendition, rhs: GraphicRendition) -> Bool {

    // Compare the first two non-equal elements
    let compared = zip(lhs.values, rhs.values)
      .first(where: !=)
      .map { $0.0 < $0.1 }

    if let compared {
      return compared
    } else {
      return lhs.values.count < rhs.values.count
    }
  }
}

extension ControlSequence {

  static func selectGraphicRendition(
    _ rendition: Set<GraphicRendition>
  ) -> ControlSequence {

    let values = rendition
      .sorted()
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
