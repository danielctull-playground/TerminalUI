import AttributeGraph

extension Optional: View where Wrapped: View {}

extension Optional: PrimitiveView where Wrapped: View {

  public static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    inputs.graph.subgraph {

      
      ViewOutputs(
        preferenceValues: inputs.graph.rule { graph in
          switch graph[view] {
          case .none: .empty
          case .some(let content):
            graph[Wrapped.makeView(view: graph.map(view) { _ in content }, inputs: inputs).preferenceValues]
          }
        },
        displayItems: inputs.graph.rule { graph in
          switch graph[view] {
          case .none: []
          case .some(let content):
            graph[Wrapped.makeView(view: graph.map(view) { _ in content }, inputs: inputs).displayItems]
          }
        }
      )
    }.1

//    let wrapped = Wrapped.makeView(view: inputs.graph.map(view, \.unsafelyUnwrapped), inputs: inputs)
  }
}
