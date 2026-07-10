import AttributeGraph

public struct AnyView: PrimitiveView {

  private let makeView: (ViewInputs) -> ViewOutputs

  public init<View: TerminalUI.View>(_ view: View) {
    makeView = { inputs in
      View.makeView(
        view: inputs.graph.constant(view),
        inputs: inputs
      )
    }
  }

  public static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    unowned let graph = inputs.graph

    // Build the erased view's subgraph together, just once.
    let content = graph.map(view) { $0.makeView(inputs) }

    return ViewOutputs(
      preferenceValues: graph.map(content) { graph[$0.preferenceValues] },
      layoutComputers: graph.map(content) { graph[$0.layoutComputers] },
      displayList: graph.map(content) { graph[$0.displayList] },
    )
  }
}
