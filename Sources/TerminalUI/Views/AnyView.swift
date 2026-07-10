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
    return ViewOutputs(
      preferenceValues: inputs.graph.rule { graph in
        graph[graph[view].makeView(inputs).preferenceValues]
      },
      layoutComputers: inputs.graph.rule { graph in
        graph[graph[view].makeView(inputs).layoutComputers]
      },
      displayList: inputs.graph.rule { graph in
        graph[graph[view].makeView(inputs).displayList]
      }
    )
  }
}
