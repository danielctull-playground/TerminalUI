
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
