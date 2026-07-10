
extension View {

  public func foregroundColor(_ color: Color) -> some View {
    environment(\.foregroundColor, color)
  }
}

extension EnvironmentValues {
  @Entry var foregroundColor = Color.default
}
