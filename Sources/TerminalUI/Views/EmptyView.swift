
public struct EmptyView: PrimitiveView {

  public init() {}

  public static func makeView(
    view: GraphValue<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[EmptyView] preference values") {
        .empty
      },
      displayItems: inputs.graph.attribute("[EmptyView] display items") {
        []
      }
    )
  }
}
