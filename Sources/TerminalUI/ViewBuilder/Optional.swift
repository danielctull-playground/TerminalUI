
extension Optional: View where Wrapped: View {}

extension Optional: PrimitiveView where Wrapped: View {

  public static func makeView(
    view: GraphValue<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[Optional] preference values") {
        switch view.value {
        case .none: .empty
        case .some(let content):
          Wrapped.makeView(view: view.map { _ in content }, inputs: inputs).preferenceValues
        }
      },
      displayItems: inputs.graph.attribute("[Optional] display items") {
        switch view.value {
        case .none: []
        case .some(let content):
          Wrapped.makeView(view: view.map { _ in content }, inputs: inputs).displayItems
        }
      }
    )
  }
}
