
extension View {

  public func environment<Value>(
    _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
    _ value: Value
  ) -> some View {
    EnvironmentModifier(content: self) { $0[keyPath: keyPath] = value }
  }
}

private struct EnvironmentModifier<Content: View>: View {

  let content: Content
  let modify: (inout EnvironmentValues) -> Void

  var body: some View {
    BuiltinView { canvas, environment in
      var environment = environment
      modify(&environment)
      content.update(canvas: canvas, environment: environment)
    }
  }
}
