import AttributeGraph

protocol DynamicView: PrimitiveView {

  associatedtype ID: Equatable

  static func childInfo(
    graph: Graph,
    view: Attribute<Self>
  ) -> ID

  static func makeChildView(
    graph: Graph,
    id: ID,
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs
}

struct ItemInfo<ID> {
  let id: ID
  let subgraph: Subgraph
  let outputs: ViewOutputs
}

extension DynamicView {

  public static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    unowned let graph = inputs.graph

    var info: ItemInfo<ID>?

    let child = graph.rule { graph in

      let id = childInfo(graph: graph, view: view)

      // Tear down if different
      if info?.id != id {

        if let old = info {
          graph.invalidate(old.subgraph)
        }

        let (subgraph, outputs) = graph.subgraph {
          makeChildView(
            graph: graph,
            id: id,
            view: view,
            inputs: inputs
          )
        }

        info = ItemInfo(id: id, subgraph: subgraph, outputs: outputs)
      }

      return info!.outputs
    }

    return ViewOutputs(
      preferenceValues: graph.map(child) { graph[$0.preferenceValues] },
      displayItems: graph.map(child) { graph[$0.displayItems] }
    )
  }
}
