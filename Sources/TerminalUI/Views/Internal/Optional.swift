
extension Optional: View where Wrapped: View {

  public var body: some View {
    fatalError("Body should never be called.")
  }

  public static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(displayItems: inputs.graph.attribute("optional") {
      switch inputs.node {
      case .none: []
      case .some(let content):
        Wrapped.makeView(inputs: inputs.modifyNode("optional") { content }).displayItems
      }
    })
  }
}
