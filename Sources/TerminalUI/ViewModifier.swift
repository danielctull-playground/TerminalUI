import AttributeGraph

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

  static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    let properties = inputs.dynamicProperties
    let buffer = DynamicPropertyBuffer(
      graph: inputs.graph,
      properties: properties,
      target: inputs.graph[view].modifier
    )

    let body = inputs.graph.map(view) { [unowned graph = inputs.graph] view in
      buffer.update(target: view.modifier, graph: graph, properties: properties)
      return view.modifier.body(content: view.content)
    }

    return Modifier.Body.makeView(view: body, inputs: inputs)
  }
}
