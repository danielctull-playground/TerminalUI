
public struct EmptyView: PrimitiveView {

  public init() {}

  public static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
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
