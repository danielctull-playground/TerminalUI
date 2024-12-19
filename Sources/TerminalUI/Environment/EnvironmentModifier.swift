
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
    for proposedSize: ProposedSize,
    environment: EnvironmentValues
  ) -> Size {
    Size(proposedSize)
  }

  func render(in canvas: any Canvas, size: Size, environment: EnvironmentValues) {
    var environment = environment
    environment[keyPath: keyPath] = value
    content._render(in: canvas, size: size, environment: environment)
  }
}
