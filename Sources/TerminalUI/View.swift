import AttributeGraph

public protocol View {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  @ViewBuilder
  var body: Body { get }

  static func makeView(view: Attribute<Self>, inputs: ViewInputs) -> ViewOutputs
}

extension View {

  public static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    let buffer = DynamicPropertyBuffer(graph: inputs.graph)

    let body = inputs.graph.map(view) { view in
      buffer.install(on: view, inputs: inputs)
      return view.body
    }

    return Body.makeView(view: body, inputs: inputs)
  }
}
