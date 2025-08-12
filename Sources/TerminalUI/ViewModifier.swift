
extension View {

  public func modifier<Modifier: ViewModifier>(
    _ modifier: Modifier
  ) -> some View where Modifier.Content == Self {
    ModifiedView(content: self, modifier: modifier)
  }
}

/// A modifier that you apply to a view or another view modifier, producing a
/// different version of the original value.
public protocol ViewModifier {

  /// The content view type passed to `body()`.
  associatedtype Content

  /// The type of view representing the body.
  associatedtype Body: View

  /// Gets the current body of the caller.
  func body(content: Content) -> Body
}

private struct ModifiedView<Modifier: ViewModifier>: View {

  let content: Modifier.Content
  let modifier: Modifier

  var body: some View {
    fatalError("Body should never be called.")
  }

  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    Modifier.Body.makeView(inputs: inputs.modifyNode("[\(Self.self)] body") {
      inputs.dynamicProperties.environment.install(on: inputs.node.modifier)
      return inputs.node.modifier.body(content: inputs.node.content)
    })
  }
}
