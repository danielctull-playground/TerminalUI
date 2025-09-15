
extension View {

  public func italic(_ isActive: Bool = true) -> some View {
    environment(\.italic, isActive ? .on : .off)
  }
}

extension EnvironmentValues {
  @Entry fileprivate(set) var italic = Italic.off
}

struct Italic: Equatable {
  let graphicRendition: GraphicRendition
  static let on = Italic(graphicRendition: 3)
  static let off = Italic(graphicRendition: 23)
}
