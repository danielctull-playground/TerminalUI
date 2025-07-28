
extension View {

  public func environment<Value>(
    _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
    _ value: Value
  ) -> some View {
    EnvironmentView(content: self, keyPath: keyPath, value: value)
  }
}

public struct EnvironmentView<Content: View, Value>: View {

  let content: Content
  let keyPath: WritableKeyPath<EnvironmentValues, Value>
  let value: Value

  public var body: some View {
    fatalError("Body should never be called.")
  }

  public static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {

    let environment = inputs.graph.attribute("environment writer") {
      let keyPath = inputs.node.keyPath
      let value = inputs.node.value
      var environment = inputs.environment
      environment[keyPath: keyPath] = value
      return environment
    }

    let inputs = ViewInputs(
      graph: inputs.graph,
      canvas: inputs.canvas,
      node: inputs.nodeAttribute.content,
      environment: environment)

    return Content.makeView(inputs: inputs)
  }
}
