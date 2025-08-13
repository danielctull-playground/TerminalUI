
extension Optional: View where Wrapped: View {

  public var body: some View {
    fatalError("Body should never be called.")
  }

  public static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[Optional] preference values") {
        switch inputs.node {
        case .none: .empty
        case .some(let content):
          Wrapped.makeView(inputs: inputs.map { _ in content }).preferenceValues
        }
      },
      displayItems: inputs.graph.attribute("[Optional] display items") {
        switch inputs.node {
        case .none: []
        case .some(let content):
          Wrapped.makeView(inputs: inputs.map { _ in content }).displayItems
        }
      }
    )
  }
}
