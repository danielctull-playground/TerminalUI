
extension Optional: View where Wrapped: View {

  public var body: some View {
    fatalError("Body should never be called.")
  }

  public static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    switch inputs.node {
    case .none: ViewOutputs(displayItems: [])
    case .some(let content): Wrapped.makeView(inputs: inputs.modifyNode("optional") { content })
    }
  }
}
