import AttributeGraph

struct Cursor: PrimitiveView {

  static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    unowned let graph = inputs.graph
    let geometry = graph.external(of: ViewGeometry.self)
    graph.setValue(of: geometry, to: .zero)

    return ViewOutputs(
      preferenceValues: graph.constant(.empty),
      layoutProxies: graph.constant([
        LayoutProxy(
          layoutComputer: LayoutComputer { _ in
            Size(width: 1, height: 1)
          },
          place: { frame in
            graph.setValue(of: geometry, to: ViewGeometry(frame: frame))
          }
        )
      ]),
      displayList: graph.map(geometry) { geometry in
        DisplayList(items: [
          DisplayList.Item(frame: geometry.frame, content: .cursor)
        ])
      }
    )
  }
}
