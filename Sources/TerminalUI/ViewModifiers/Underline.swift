
extension View {

  public func underline(_ isActive: Bool = true) -> some View {
    environment(\.underline, isActive ? .on : .off)
  }
}

private struct UnderlineEnvironmentKey: EnvironmentKey {
  static var defaultValue: Underline { .off }
}

extension EnvironmentValues {
  var underline: Underline {
    get { self[UnderlineEnvironmentKey.self] }
    set { self[UnderlineEnvironmentKey.self] = newValue }
  }
}

struct Underline: Equatable {
  let sgr: SelectGraphicRendition
  static let on = Underline(sgr: 4)
  static let off = Underline(sgr: 24)
}
