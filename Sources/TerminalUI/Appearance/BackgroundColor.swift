
extension View {

  public func backgroundColor(_ color: Color) -> some View {
    environment(\.backgroundColor, color)
  }
}

extension EnvironmentValues {
  @Entry fileprivate(set) var backgroundColor = Color.default
}
