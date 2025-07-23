
struct Accumulated<A: View, B: View>: Builtin, View {

  private let a: A
  private let b: B

  init(_ a: A, _ b: B) {
    self.a = a
    self.b = b
  }

  func displayItems(inputs: ViewInputs) -> [DisplayItem] {
    a.displayItems(inputs: inputs) + b.displayItems(inputs: inputs)
  }
}
