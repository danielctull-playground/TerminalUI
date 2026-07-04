import AttributeGraph

struct DynamicContainer<ID: Hashable> {

  private unowned let graph: Graph
  private(set) var items: [ItemInfo<ID>] = []

  init(graph: Graph) {
    self.graph = graph
  }
}

extension DynamicContainer {

  mutating func update(ids: [ID], build: (ID) -> (ViewOutputs)) {

    var lookup = Dictionary(items.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
    items = []

    for id in ids {

      if let info = lookup.removeValue(forKey: id) {
        items.append(info)
        continue
      }

      let (subgraph, outputs) = graph.subgraph {
        build(id)
      }

      let info = ItemInfo(
        id: id,
        subgraph: subgraph,
        outputs: outputs
      )

      items.append(info)
    }

    for info in lookup.values {
      graph.invalidate(info.subgraph)
    }
  }
}
