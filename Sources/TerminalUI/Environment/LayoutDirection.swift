
extension View {

  func layoutDirection(_ layoutDirection: LayoutDirection) -> some View {
    environment(\.layoutDirection, layoutDirection)
  }
}

extension EnvironmentValues {
  @Entry fileprivate(set) var layoutDirection = LayoutDirection.vertical
}

enum LayoutDirection: Equatable {
  case horizontal
  case vertical
}
