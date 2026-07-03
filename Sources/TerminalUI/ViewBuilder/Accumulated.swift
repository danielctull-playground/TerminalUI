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
    let a = A.makeView(view: inputs.graph.map(view, \.a), inputs: inputs)
    let b = B.makeView(view: inputs.graph.map(view, \.b), inputs: inputs)
    return ViewOutputs(
      preferenceValues: inputs.graph.rule { graph in
        PreferenceValues(
          lhs: graph[a.preferenceValues],
          rhs: graph[b.preferenceValues]
        )
      },
      displayItems: inputs.graph.rule { graph in
        graph[a.displayItems] + graph[b.displayItems]
      }
    )
  }
}
