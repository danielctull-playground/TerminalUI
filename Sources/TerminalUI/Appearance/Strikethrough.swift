
extension View {

  public func strikethrough(_ isActive: Bool = true) -> some View {
    environment(\.strikethrough, isActive ? .on : .off)
  }
}

extension EnvironmentValues {
  @Entry fileprivate(set) var strikethrough = Strikethrough.off
}

struct Strikethrough: Equatable {
  let graphicRendition: GraphicRendition
  static let on = Strikethrough(graphicRendition: 9)
  static let off = Strikethrough(graphicRendition: 29)
}
