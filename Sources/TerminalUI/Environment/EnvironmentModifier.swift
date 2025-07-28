
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

  func makeView(inputs: ViewInputs) -> ViewOutputs {
    var environment = inputs.environment
    environment[keyPath: keyPath] = value
    let inputs = ViewInputs(canvas: inputs.canvas, environment: environment)
    return content.makeView(inputs: inputs)
  }
}
