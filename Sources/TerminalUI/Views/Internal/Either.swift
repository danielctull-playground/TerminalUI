
public struct Either<First: View, Second: View>: Builtin, View {

  private enum Value {
    case first(First)
    case second(Second)
  }

  private let value: Value

  init(_ first: First) {
    value = .first(first)
  }

  init(_ second: Second) {
    value = .second(second)
  }

  func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    switch inputs.node.value {
    case let .first(first):
      First.makeView(inputs: inputs.modifyNode("first") { first })
    case let .second(second):
      Second.makeView(inputs: inputs.modifyNode("second") { second })
    }
  }
}
