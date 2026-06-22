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

    inputs.graph.subgraph {

      let properties = inputs.dynamicProperties
      let buffer = DynamicPropertyBuffer(
        graph: inputs.graph,
        properties: properties,
        target: inputs.graph[view]
      )

      let body = inputs.graph.map(view) { [unowned graph = inputs.graph] view in
        buffer.update(target: view, graph: graph, properties: properties)
        return view.body
      }

      return Body.makeView(view: body, inputs: inputs)

    }.1
  }
}
