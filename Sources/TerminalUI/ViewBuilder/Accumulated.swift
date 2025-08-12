
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
      preferences: inputs.graph.attribute("[Accumulated] preferences") {
        PreferenceValues { key in
          key.value(
            lhs: A.makeView(inputs: inputs.a).preferences,
            rhs: B.makeView(inputs: inputs.b).preferences
          )
        }
      },
      displayItems: inputs.graph.attribute("[Accumulated] displayItems") {
        let a = A.makeView(inputs: inputs.a)
        let b = B.makeView(inputs: inputs.b)
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
