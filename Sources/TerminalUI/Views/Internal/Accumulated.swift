
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
    ViewOutputs(displayItems: inputs.graph.attribute("accumulated") {
      let a = A.makeView(inputs: inputs.a)
      let b = B.makeView(inputs: inputs.b)
      return a.displayItems + b.displayItems
    })
  }
}
