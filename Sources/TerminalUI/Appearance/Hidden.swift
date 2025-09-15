
extension View {

  public func hidden(_ isActive: Bool = true) -> some View {
    environment(\.hidden, isActive ? .on : .off)
  }
}

extension EnvironmentValues {
  @Entry fileprivate(set) var hidden = Hidden.off
}

struct Hidden: Equatable {
  let graphicRendition: GraphicRendition
  static let on = Hidden(graphicRendition: 8)
  static let off = Hidden(graphicRendition: 28)
}
