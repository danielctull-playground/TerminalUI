
extension View {

  public func environment<Value>(
    _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
    _ value: Value
  ) -> some View {
    EnvironmentView(content: self, keyPath: keyPath, value: value)
  }
}

private struct EnvironmentView<Content: View, Value>: Builtin {

  let content: Content
  let keyPath: WritableKeyPath<EnvironmentValues, Value>
  let value: Value

  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
//    let content = inputs.content
//    var environment = inputs.environment
//    environment[keyPath: content.keyPath] = content.value
//
//

    

  }

  func size(
    for proposal: ProposedViewSize,
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
