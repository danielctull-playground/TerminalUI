
public struct EmptyView: View {

  public init() {}

  public var body: some View {
    fatalError("Body should never be called.")
  }

  public static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[EmptyView] preference values") {
        .empty
      },
      displayItems: inputs.graph.attribute("[EmptyView] displayItems") {
        []
      }
    )
  }
}
