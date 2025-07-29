
extension Optional: Builtin & View where Wrapped: View {

  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    switch inputs.node {
    case .none: ViewOutputs(displayItems: [])
    case .some(let content): Wrapped.makeView(inputs: inputs.modifyNode("optional") { content })
    }
  }
}
