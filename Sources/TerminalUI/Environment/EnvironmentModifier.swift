
extension View {

  public func environment<Value>(
    _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
    _ value: Value
  ) -> some View {
    EnvironmentView(content: self, keyPath: keyPath, value: value)
  }
}

private struct EnvironmentView<Content: View, Value> {
  let content: Content
  let keyPath: WritableKeyPath<EnvironmentValues, Value>
  let value: Value
}

extension EnvironmentView: View {

  var body: some View {
    fatalError()
  }

  static func _makeView(
    _ inputs: ViewInputs<EnvironmentView<Content, Value>>
  ) -> ViewOutputs {

    var inputs = inputs
    //    inputs.environment[keyPath: inputs.keyPath.node] = inputs.value.node

    return Content._makeView(inputs.content)
  }
}
