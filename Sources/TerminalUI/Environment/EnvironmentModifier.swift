
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
    for proposal: ProposedViewSize,
    inputs: ViewInputs
  ) -> Size {
    var environment = inputs.environment
    environment[keyPath: keyPath] = value
    let inputs = ViewInputs(environment: environment)
    return content._size(for: proposal, inputs: inputs)
  }

  func render(in canvas: any Canvas, bounds: Rect, inputs: ViewInputs) {
    var environment = inputs.environment
    environment[keyPath: keyPath] = value
    let inputs = ViewInputs(environment: environment)
    content._render(in: canvas, bounds: bounds, inputs: inputs)
  }
}
