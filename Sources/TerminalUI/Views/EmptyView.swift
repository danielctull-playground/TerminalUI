import AttributeGraph

public struct EmptyView: PrimitiveView {

  public init() {}

  public static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.constant(.empty),
      layoutComputers: inputs.graph.constant([])
    )
  }
}
