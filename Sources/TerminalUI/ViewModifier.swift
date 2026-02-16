
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

private struct ModifiedView<Modifier: ViewModifier>: PrimitiveView {

  let content: Modifier.Content
  let modifier: Modifier

  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[\(Self.self)] preference values") {
        inputs.dynamicProperties.install(on: inputs.node.modifier)
        let inputs = inputs.mapNode { $0.modifier.body(content: inputs.node.content) }
        return Modifier.Body.makeView(inputs: inputs).preferenceValues
      },
      displayItems: inputs.graph.attribute("[\(Self.self)] display items") {
        inputs.dynamicProperties.install(on: inputs.node.modifier)
        let inputs = inputs.mapNode { $0.modifier.body(content: inputs.node.content) }
        return Modifier.Body.makeView(inputs: inputs).displayItems
      }
    )
  }
}
