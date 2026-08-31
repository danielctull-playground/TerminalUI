import AttributeGraph

extension View {

  public func background<Content: View>(
    alignment: Alignment = .center,
    @ViewBuilder content: () -> Content
  ) -> some View {
    Background(
      alignment: alignment,
      content: self,
      background: content()
    )
  }
}

private struct Background<Content: View, BackgroundContent: View> {
  let alignment: Alignment
  let content: Content
  let background: BackgroundContent
}

extension Background: PrimitiveView {

  static func makeView(
    view: Attribute<Background<Content, BackgroundContent>>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    unowned let graph = inputs.graph
    let content = Content.makeView(
      view: graph.map(view) { $0.content },
      inputs: inputs
    )

    let background = BackgroundContent.makeView(
      view: graph.map(view) { $0.background },
      inputs: inputs
    )

    return ViewOutputs(
      preferenceValues: <#T##Attribute<PreferenceValues>#>,
      layoutProxies: content.layoutProxies,
      displayList: graph.rule { graph in
        graph.
      }
    )





  }
}
