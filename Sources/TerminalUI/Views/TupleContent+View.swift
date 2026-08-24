import AttributeGraph

extension TupleContent: View where repeat each Content: View {}

extension TupleContent: PrimitiveView where repeat each Content: View {

  public static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    let child = (repeat inputs.graph.map(view) { tuple in
      each tuple.content
    })

    let outputs = (repeat (each Content).makeView(view: each child, inputs: inputs))

    return ViewOutputs(
      preferenceValues: inputs.graph.rule { _ in
        PreferenceValues.empty
      },
      layoutProxies: inputs.graph.rule { graph in
        (repeat graph[each outputs.layoutProxies]).reduce([], +)
      },
      displayList: inputs.graph.rule { graph in
        DisplayList(items: (repeat graph[each outputs.displayList].items).reduce([], +))
      }
    )
  }
}
