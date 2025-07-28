
struct Accumulated<A: View, B: View>: Builtin, View {

  private let a: A
  private let b: B

  init(_ a: A, _ b: B) {
    self.a = a
    self.b = b
  }

  func makeView(inputs: ViewInputs) -> ViewOutputs {
    let a = a.makeView(inputs: inputs)
    let b = b.makeView(inputs: inputs)
    return ViewOutputs(displayItems: a.displayItems + b.displayItems)
  }
}
