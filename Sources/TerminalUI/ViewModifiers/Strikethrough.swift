
extension View {

  public func strikethrough(_ isActive: Bool = true) -> some View {
    environment(\.strikethrough, isActive ? .on : .off)
  }
}

private struct StrikethroughEnvironmentKey: EnvironmentKey {
  static var defaultValue: Strikethrough { .off }
}

extension EnvironmentValues {
  var strikethrough: Strikethrough {
    get { self[StrikethroughEnvironmentKey.self] }
    set { self[StrikethroughEnvironmentKey.self] = newValue }
  }
}

struct Strikethrough: Equatable {
  let controlSequence: ControlSequence
  static let on = Strikethrough(controlSequence: .selectGraphicRendition(9))
  static let off = Strikethrough(controlSequence: .selectGraphicRendition(29))
}
