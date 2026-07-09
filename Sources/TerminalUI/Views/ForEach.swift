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

    var container = DynamicContainer<ID>(graph: inputs.graph)
    unowned let graph = inputs.graph

    let children = graph.rule { graph in

      let data = graph[view].data
      let id = graph[view].id
      let content = graph[view].content

      let ids = data.indices.map { data[$0][keyPath: id] }

      container.update(ids: ids) { id in
        Content.makeView(
          view: graph.map(view) { view in
            content(view.data.first { $0[keyPath: view.id] == id }!)
          },
          inputs: inputs
        )
      }

      let items = container.items
      return ViewOutputs(
        preferenceValues: graph.rule { graph in
          items.reduce(PreferenceValues { _ in nil }) { result, info in
            PreferenceValues(
              lhs: result,
              rhs: graph[info.outputs.preferenceValues]
            )
          }
        },
        layoutComputers: graph.rule { graph in
          items.reduce(into: []) { result, info in
            result.append(contentsOf: graph[info.outputs.layoutComputers])
          }
        }
      )
    }

    return ViewOutputs(
      preferenceValues: graph.map(children) { graph[$0.preferenceValues] },
      layoutComputers: graph.map(children) { graph[$0.layoutComputers] }
    )
  }
}
