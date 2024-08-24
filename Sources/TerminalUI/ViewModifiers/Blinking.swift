
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
  let sgr: SelectGraphicRendition
  static let on = Blinking(sgr: 5)
  static let off = Blinking(sgr: 25)
}
