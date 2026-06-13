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

    let body = inputs.graph.map(view) { view in
      inputs.dynamicProperties.install(on: view)
      return view.body
    }

    return Body.makeView(view: body, inputs: inputs)
  }
}
