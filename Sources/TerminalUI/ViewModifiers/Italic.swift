
extension View {

  public func italic(_ isActive: Bool = true) -> some View {
    environment(\.italic, isActive ? .on : .off)
  }
}

private struct ItalicEnvironmentKey: EnvironmentKey {
  static var defaultValue: Italic { .off }
}

extension EnvironmentValues {
  var italic: Italic {
    get { self[ItalicEnvironmentKey.self] }
    set { self[ItalicEnvironmentKey.self] = newValue }
  }
}

struct Italic: Equatable {
  let sgr: SelectGraphicRendition
  static let on = Italic(sgr: 3)
  static let off = Italic(sgr: 23)
}
