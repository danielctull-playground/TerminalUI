import AttributeGraph

public struct ForEach<Data: RandomAccessCollection, ID: Hashable, Content: View> {
  private let data: Data
  private let id: KeyPath<Data.Element, ID>
  private let content: (Data.Element) -> Content

  public init(
    _ data: Data,
    id: KeyPath<Data.Element, ID>,
    content: @escaping (Data.Element) -> Content
  ) {
    self.data = data
    self.id = id
    self.content = content
  }
}

extension ForEach: PrimitiveView {

  public static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    unowned let graph = inputs.graph

    var infos: [ItemInfo<ID>] = []

    let children = graph.rule { graph in

      let data = graph[view].data
      let id = graph[view].id
      let content = graph[view].content

      var old = infos
      infos = []

      for index in data.indices {

        let id = data[index][keyPath: id]

        if let info = old.first(where: { $0.id == id }) {
          infos.append(info)
          continue
        }

        let (subgraph, outputs) = graph.subgraph {
          Content.makeView(
            view: graph.map(view) { view in
              content(view.data.first { $0[keyPath: view.id] == id }!)
            },
            inputs: inputs
          )
        }

        let info = ItemInfo(
          id: id,
          subgraph: subgraph,
          outputs: outputs
        )

        infos.append(info)
      }

      old.removeAll(where: { old in infos.contains(where: { $0.id == old.id })})

      for item in old {
        graph.invalidate(item.subgraph)
      }

      return ViewOutputs(
        preferenceValues: graph.rule { graph in
          infos.reduce(PreferenceValues { _ in nil }) { result, info in
            PreferenceValues(
              lhs: result,
              rhs: graph[info.outputs.preferenceValues]
            )
          }
        },
        displayItems: graph.rule { graph in
          infos.reduce(into: []) { result, info in
            result.append(contentsOf: graph[info.outputs.displayItems])
          }
        }
      )
    }

    return ViewOutputs(
      preferenceValues: graph.map(children) { graph[$0.preferenceValues] },
      displayItems: graph.map(children) { graph[$0.displayItems] }
    )
  }
}
