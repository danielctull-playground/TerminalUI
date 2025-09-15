
extension View {

  public func bold(_ isActive: Bool = true) -> some View {
    environment(\.bold, isActive ? .on : .off)
  }
}

extension EnvironmentValues {
  @Entry fileprivate(set) var bold = Bold.off
}

struct Bold: Equatable {
  let graphicRendition: GraphicRendition
  static let on = Bold(graphicRendition: 1)
  static let off = Bold(graphicRendition: 22)
}
