
extension View {

  public func environment<Value>(
    _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
    _ value: Value
  ) -> some View {
    modifier(EnvironmentModifier { $0[keyPath: keyPath] = value })
  }
}

private struct EnvironmentModifier<Content: View>: ViewModifier {

  let modify: (inout EnvironmentValues) -> Void

  func body(content: Content) -> some View {
    BuiltinView { canvas, environment in
      var environment = environment
      modify(&environment)
      content.update(canvas: canvas, environment: environment)
    }
  }
}
