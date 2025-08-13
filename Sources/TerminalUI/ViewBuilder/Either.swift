
public struct Either<First: View, Second: View>: View {

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

  public var body: some View {
    fatalError("Body should never be called.")
  }

  public static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[Either] preference values") {
        switch inputs.node.value {
        case let .first(first):
          First.makeView(inputs: inputs.map { _ in first }).preferenceValues
        case let .second(second):
          Second.makeView(inputs: inputs.map { _ in second }).preferenceValues
        }
      },
      displayItems: inputs.graph.attribute("[Either] display items") {
        switch inputs.node.value {
        case let .first(first):
          First.makeView(inputs: inputs.map { _ in first }).displayItems
        case let .second(second):
          Second.makeView(inputs: inputs.map { _ in second }).displayItems
        }
      }
    )
  }
}
