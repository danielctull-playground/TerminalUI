
extension View {

  public func foregroundColor(_ color: Color) -> some View {
    environment(\.foregroundColor, color)
  }
}

extension EnvironmentValues {
  @Entry fileprivate(set) var foregroundColor = Color.default
}
