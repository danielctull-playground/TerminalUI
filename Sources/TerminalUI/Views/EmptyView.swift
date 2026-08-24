import AttributeGraph

public typealias EmptyView = EmptyContent

extension EmptyContent: PrimitiveView {

  public static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.constant(.empty),
      layoutProxies: inputs.graph.constant([]),
      displayList: inputs.graph.constant(.empty)
    )
  }
}
