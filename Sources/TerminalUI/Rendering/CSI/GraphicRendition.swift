
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

    let parameters = rendition.reduce([] as CSI.Parameters) { a, b in
      a.appending(b.parameters)
    }

    return CSI(parameters: parameters, command: "m")
  }
}
