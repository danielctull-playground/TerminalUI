
extension Optional: Builtin & View where Wrapped: View {

  func makeView(inputs: ViewInputs) -> ViewOutputs {
    switch self {
    case .none: ViewOutputs(displayItems: [])
    case .some(let content): content.makeView(inputs: inputs)
    }
  }
}
