
public struct AnyView: PrimitiveView {

  private let makeView: (ViewInputs) -> ViewOutputs

  public init<View: TerminalUI.View>(_ view: View) {
    makeView = { inputs in
      View.makeView(
        view: GraphValue(
          value: inputs.graph.attribute("[AnyView (\(type(of: View.self))]") { view }
        ),
        inputs: inputs
      )
    }
  }

  public static func makeView(
    view: GraphValue<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[AnyView] preference values") {
        view.value.makeView(inputs).preferenceValues
      },
      displayItems: inputs.graph.attribute("[AnyView] display items") {
        view.value.makeView(inputs).displayItems
      }
    )
  }
}
