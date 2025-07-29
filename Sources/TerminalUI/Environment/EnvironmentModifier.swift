
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

  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {

    let environment = inputs.graph.attribute("environment writer") {
      var environment = inputs.environment
      environment[keyPath: inputs.node.keyPath] = inputs.node.value
      return environment
    }

    var inputs = inputs.content
//    inputs._environment = environment
    return Content.makeView(inputs: inputs)
  }
}
