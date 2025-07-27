
extension View {

  public func strikethrough(_ isActive: Bool = true) -> some View {
    environment(\.strikethrough, isActive ? .on : .off)
  }
}

private struct StrikethroughEnvironmentKey: EnvironmentKey {
  static var defaultValue: Strikethrough { .off }
}

extension EnvironmentValues {
  fileprivate(set) var strikethrough: Strikethrough {
    get { self[StrikethroughEnvironmentKey.self] }
    set { self[StrikethroughEnvironmentKey.self] = newValue }
  }
}

struct Strikethrough: Equatable {
  let graphicRendition: GraphicRendition
  static let on = Strikethrough(graphicRendition: 9)
  static let off = Strikethrough(graphicRendition: 29)
}
