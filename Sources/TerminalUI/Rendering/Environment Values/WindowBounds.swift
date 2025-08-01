
extension EnvironmentValues {
  var windowBounds: Rect  {
    get { self[WindowBoundsEnvironmentKey.self] }
    set { self[WindowBoundsEnvironmentKey.self] = newValue }
  }
}

private struct WindowBoundsEnvironmentKey: EnvironmentKey {
  static var defaultValue: Rect { Rect(origin: .origin, size: .zero) }
}
