
struct Accumulated<A: View, B: View>: View {

  private let a: A
  private let b: B

  init(_ a: A, _ b: B) {
    self.a = a
    self.b = b
  }

  var body: some View {
    fatalError("Body should never be called.")
  }

  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[Accumulated] preference values") {
        PreferenceValues { key in
          key.value(
            lhs: A.makeView(inputs: inputs.mapNode(\.a)).preferenceValues,
            rhs: B.makeView(inputs: inputs.mapNode(\.b)).preferenceValues
          )
        }
      },
      displayItems: inputs.graph.attribute("[Accumulated] display items") {
        let a = A.makeView(inputs: inputs.mapNode(\.a))
        let b = B.makeView(inputs: inputs.mapNode(\.b))
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
