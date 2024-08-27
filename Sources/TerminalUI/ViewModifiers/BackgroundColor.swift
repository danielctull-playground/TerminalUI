
extension View {

  public func backgroundColor(_ color: Color) -> some View {
    environment(\.backgroundColor, color)
  }
}

private struct BackgroundColorEnvironmentKey: EnvironmentKey {
  static var defaultValue: Color { .default }
}

extension EnvironmentValues {
  var backgroundColor: Color {
    get { self[BackgroundColorEnvironmentKey.self] }
    set { self[BackgroundColorEnvironmentKey.self] = newValue }
  }
}
