
extension View {

  public func hidden(_ isActive: Bool = true) -> some View {
    environment(\.hidden, isActive ? .on : .off)
  }
}

private struct HiddenEnvironmentKey: EnvironmentKey {
  static var defaultValue: Hidden { .off }
}

extension EnvironmentValues {
  var hidden: Hidden {
    get { self[HiddenEnvironmentKey.self] }
    set { self[HiddenEnvironmentKey.self] = newValue }
  }
}

struct Hidden: Equatable {
  let sgr: SelectGraphicRendition
  static let on = Hidden(sgr: 8)
  static let off = Hidden(sgr: 28)
}
