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

    let children = graph.rule { graph in

      let data = graph[view].data
      let id = graph[view].id
      let content = graph[view].content

      var infos: [ItemInfo<ID>] = []
      infos.reserveCapacity(data.count)

      for index in data.indices {

        let (subgraph, outputs) = graph.subgraph {
          Content.makeView(
            view: graph.map(view) { content($0.data[index]) },
            inputs: inputs
          )
        }

        let info = ItemInfo(
          id: data[index][keyPath: id],
          subgraph: subgraph,
          outputs: outputs
        )

        infos.append(info)
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
