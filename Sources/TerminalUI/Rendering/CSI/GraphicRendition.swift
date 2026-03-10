
struct GraphicRendition: Equatable, Hashable {
  fileprivate let parameters: CSI.Parameters
}

extension GraphicRendition: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self.init(parameters: CSI.Parameters([CSI.Parameter(value)]))
  }
}

extension GraphicRendition: ExpressibleByArrayLiteral {
  init(arrayLiteral elements: Int...) {
    self.init(parameters: CSI.Parameters(elements.map(CSI.Parameter.init(_:))))
  }
}

extension CSI {

  static func selectGraphicRendition(
    _ rendition: [GraphicRendition]
  ) -> CSI {
    CSI(
      parameters: rendition.map(\.parameters).reduce([]) { $0.appending($1) },
      command: "m"
    )
  }
}
