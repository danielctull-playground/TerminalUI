
public struct AnyView: View {

  private let makeView: (ViewInputs<AnyView>) -> ViewOutputs

  public init<View: TerminalUI.View>(_ view: View) {
    makeView = { inputs in
      let inputs = inputs.mapNode { _ in view }
      return View.makeView(inputs: inputs)
    }
  }

  public var body: some View {
    fatalError("Body should never be called.")
  }

  public static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[AnyView] preference values") {
        inputs.node.makeView(inputs).preferenceValues
      },
      displayItems: inputs.graph.attribute("[AnyView] display items") {
        inputs.node.makeView(inputs).displayItems
      }
    )
  }
}
