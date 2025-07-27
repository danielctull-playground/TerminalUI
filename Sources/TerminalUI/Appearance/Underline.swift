
extension View {

  public func underline(_ isActive: Bool = true) -> some View {
    environment(\.underline, isActive ? .on : .off)
  }
}

private struct UnderlineEnvironmentKey: EnvironmentKey {
  static var defaultValue: Underline { .off }
}

extension EnvironmentValues {
  fileprivate(set) var underline: Underline {
    get { self[UnderlineEnvironmentKey.self] }
    set { self[UnderlineEnvironmentKey.self] = newValue }
  }
}

struct Underline: Equatable {
  let graphicRendition: GraphicRendition
  static let on = Underline(graphicRendition: 4)
  static let off = Underline(graphicRendition: 24)
}
