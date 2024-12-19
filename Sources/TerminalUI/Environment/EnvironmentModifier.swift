
extension View {

  public func environment<Value>(
    _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
    _ value: Value
  ) -> some View {
    EnvironmentView(content: self, keyPath: keyPath, value: value)
  }
}

private struct EnvironmentView<Content: View, Value>: Builtin, View {

  let content: Content
  let keyPath: WritableKeyPath<EnvironmentValues, Value>
  let value: Value

  func size(
    for proposal: ProposedSize,
    environment: EnvironmentValues
  ) -> Size {
    var environment = environment
    environment[keyPath: keyPath] = value
    return content._size(for: proposal, environment: environment)
  }

  func render(in canvas: any Canvas, size: Size, environment: EnvironmentValues) {
    var environment = environment
    environment[keyPath: keyPath] = value
    content._render(in: canvas, size: size, environment: environment)
  }
}
