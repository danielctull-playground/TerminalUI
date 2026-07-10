
extension View {

  public func backgroundColor(_ color: Color) -> some View {
    environment(\.backgroundColor, color)
  }
}

extension EnvironmentValues {
  @Entry var backgroundColor = Color.default
}
