
extension Optional: View where Wrapped: View {

  public var body: some View {
    fatalError("Body should never be called.")
  }

  public static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(
      preferences: inputs.graph.attribute("[Optional] preferences") {
        switch inputs.node {
        case .none: .empty
        case .some(let content):
          Wrapped.makeView(inputs: inputs.modifyNode("optional") { content }).preferences
        }
      },
      displayItems: inputs.graph.attribute("[Optional] displayItems") {
        switch inputs.node {
        case .none: []
        case .some(let content):
          Wrapped.makeView(inputs: inputs.modifyNode("optional") { content }).displayItems
        }
      }
    )
  }
}
