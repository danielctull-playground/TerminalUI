
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
  let controlSequence: ControlSequence
  static let on = Italic(controlSequence: .selectGraphicRendition(3))
  static let off = Italic(controlSequence: .selectGraphicRendition(23))
}
