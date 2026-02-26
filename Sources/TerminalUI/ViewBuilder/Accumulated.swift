
struct Accumulated<A: View, B: View>: PrimitiveView {

  private let a: A
  private let b: B

  init(_ a: A, _ b: B) {
    self.a = a
    self.b = b
  }

  static func makeView(
    view: GraphValue<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[Accumulated] preference values") {
        PreferenceValues { key in
          key.value(
            lhs: A.makeView(view: view.a, inputs: inputs).preferenceValues,
            rhs: B.makeView(view: view.b, inputs: inputs).preferenceValues
          )
        }
      },
      displayItems: inputs.graph.attribute("[Accumulated] display items") {
        let a = A.makeView(view: view.a, inputs: inputs)
        let b = B.makeView(view: view.b, inputs: inputs)
        return a.displayItems + b.displayItems
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
