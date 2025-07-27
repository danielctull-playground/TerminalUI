
extension View {

  public func italic(_ isActive: Bool = true) -> some View {
    environment(\.italic, isActive ? .on : .off)
  }
}

private struct ItalicEnvironmentKey: EnvironmentKey {
  static var defaultValue: Italic { .off }
}

extension EnvironmentValues {
  fileprivate(set) var italic: Italic {
    get { self[ItalicEnvironmentKey.self] }
    set { self[ItalicEnvironmentKey.self] = newValue }
  }
}

struct Italic: Equatable {
  let graphicRendition: GraphicRendition
  static let on = Italic(graphicRendition: 3)
  static let off = Italic(graphicRendition: 23)
}
