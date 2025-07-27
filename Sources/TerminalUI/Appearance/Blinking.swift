
extension View {

  public func blinking(_ isActive: Bool = true) -> some View {
    environment(\.blinking, isActive ? .on : .off)
  }
}

private struct BlinkingEnvironmentKey: EnvironmentKey {
  static var defaultValue: Blinking { .off }
}

extension EnvironmentValues {
  fileprivate(set) var blinking: Blinking {
    get { self[BlinkingEnvironmentKey.self] }
    set { self[BlinkingEnvironmentKey.self] = newValue }
  }
}

struct Blinking: Equatable {
  let graphicRendition: GraphicRendition
  static let on = Blinking(graphicRendition: 5)
  static let off = Blinking(graphicRendition: 25)
}
