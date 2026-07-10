import AttributeGraph

struct Accumulated<A: View, B: View>: PrimitiveView {

  private let a: A
  private let b: B

  init(_ a: A, _ b: B) {
    self.a = a
    self.b = b
  }

  static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    let a = A.makeView(view: inputs.graph.map(view) { $0.a }, inputs: inputs)
    let b = B.makeView(view: inputs.graph.map(view) { $0.b }, inputs: inputs)
    return ViewOutputs(
      preferenceValues: inputs.graph.rule { graph in
        PreferenceValues(
          lhs: graph[a.preferenceValues],
          rhs: graph[b.preferenceValues]
        )
      },
      layoutProxies: inputs.graph.rule { graph in
        graph[a.layoutProxies] + graph[b.layoutProxies]
      },
      displayList: inputs.graph.rule { graph in
        DisplayList(items: graph[a.displayList].items + graph[b.displayList].items)
      }
    )
  }
}
