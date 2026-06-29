import AttributeGraph

extension Optional: View where Wrapped: View {}

extension Optional: PrimitiveView where Wrapped: View {

  public static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    let (_, wrapped) = inputs.graph.subgraph {
      Wrapped.makeView(
        view: inputs.graph.map(view, \.unsafelyUnwrapped),
        inputs: inputs
      )
    }

    return ViewOutputs(
      preferenceValues: inputs.graph.rule { graph in
        switch graph[view] {
        case .none: .empty
        case .some: graph[wrapped.preferenceValues]
        }
      },
      displayItems: inputs.graph.rule { graph in
        switch graph[view] {
        case .none: []
        case .some: graph[wrapped.displayItems]
        }
      }
    )
  }
}
