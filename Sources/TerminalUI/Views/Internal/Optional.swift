
extension Optional: Builtin & View where Wrapped: View {

  func displayItems(inputs: ViewInputs) -> [DisplayItem] {
    switch self {
    case .none: []
    case .some(let content): content.displayItems(inputs: inputs)
    }
  }
}
