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
        PreferenceValues { key in
          key.value(
            lhs: graph[a.preferenceValues],
            rhs: graph[b.preferenceValues]
          )
        }
      },
      displayItems: inputs.graph.rule { graph in
        graph[a.displayItems] + graph[b.displayItems]
      }
    )
  }
}

extension PreferenceKey {
  fileprivate static func value(
    lhs: PreferenceValues,
    rhs: PreferenceValues
  ) -> Value {
    switch (lhs[self], rhs[self]) {
    case (.none, .none): return defaultValue
    case (.none, .some(let rhs)): return rhs
    case (.some(let lhs), .none): return lhs
    case (.some(var lhs), .some(let rhs)):
      reduce(value: &lhs) { rhs }
      return lhs
    }
  }
}
