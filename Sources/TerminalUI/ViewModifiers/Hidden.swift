
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
  let controlSequence: ControlSequence
  static let on = Hidden(controlSequence: .selectGraphicRendition(8))
  static let off = Hidden(controlSequence: .selectGraphicRendition(28))
}
