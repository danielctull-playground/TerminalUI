import AttributeGraph

extension View {

  public func hidden(_ isActive: Bool = true) -> some View {
    Hidden(content: self, isActive: isActive)
  }
}

private struct Hidden<Content: View> {
  let content: Content
  let isActive: Bool
}

extension Hidden: PrimitiveView {

  static func makeView(
    view: Attribute<Hidden>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    let content = Content.makeView(
      view: inputs.graph.map(view) { $0.content },
      inputs: inputs
    )

    return ViewOutputs(
      preferenceValues: content.preferenceValues,
      layoutProxies: content.layoutProxies,
      displayList: inputs.graph.rule { graph in
        graph[view].isActive
          ? .empty
          : graph[content.displayList]
      }
    )
  }
}
