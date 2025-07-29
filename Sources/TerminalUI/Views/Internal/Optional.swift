
extension Optional: Builtin & View where Wrapped: View {

  func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    switch self {
    case .none: ViewOutputs(displayItems: [])
    case .some(let content): content.makeView(inputs: inputs)
    }
  }
}
