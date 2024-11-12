
extension View {

  public func blinking(_ isActive: Bool = true) -> some View {
    environment(\.blinking, isActive ? .on : .off)
  }
}

private struct BlinkingEnvironmentKey: EnvironmentKey {
  static var defaultValue: Blinking { .off }
}

extension EnvironmentValues {
  var blinking: Blinking {
    get { self[BlinkingEnvironmentKey.self] }
    set { self[BlinkingEnvironmentKey.self] = newValue }
  }
}

struct Blinking: Equatable {
  let controlSequence: ControlSequence
  static let on = Blinking(controlSequence: .selectGraphicRendition(5))
  static let off = Blinking(controlSequence: .selectGraphicRendition(25))
}
