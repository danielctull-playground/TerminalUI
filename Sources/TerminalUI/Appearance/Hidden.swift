
extension View {

  public func hidden(_ isActive: Bool = true) -> some View {
    environment(\.hidden, isActive ? .on : .off)
  }
}

private struct HiddenEnvironmentKey: EnvironmentKey {
  static var defaultValue: Hidden { .off }
}

extension EnvironmentValues {
  fileprivate(set) var hidden: Hidden {
    get { self[HiddenEnvironmentKey.self] }
    set { self[HiddenEnvironmentKey.self] = newValue }
  }
}

struct Hidden: Equatable {
  let graphicRendition: GraphicRendition
  static let on = Hidden(graphicRendition: 8)
  static let off = Hidden(graphicRendition: 28)
}
