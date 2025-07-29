
public struct Either<First: View, Second: View>: Builtin, View {

  private enum Value {
    case first(First)
    case second(Second)
  }

  private let value2: Value

  init(_ first: First) {
    value = .first(first)
  }

  init(_ second: Second) {
    value = .second(second)
  }

  func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    let f = inputs.value.value2
    switch inputs.value.value2 {
    case .first(let first): first.makeView(inputs: inputs)
    case .second(let second): second.makeView(inputs: inputs)
    }
  }
}
