
public struct EmptyView: View {

  public init() {}

  public var body: some View {
    fatalError("Body should never be called.")
  }

  public static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(
      preferences: inputs.graph.attribute("[EmptyView] preferences") {
        .empty
      },
      displayItems: inputs.graph.attribute("[EmptyView] displayItems") {
        []
      }
    )
  }
}
