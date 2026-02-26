
public struct Either<First: View, Second: View>: PrimitiveView {

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

  public static func makeView(
    view: GraphValue<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[Either] preference values") {
        switch view.value.value {
        case let .first(first):
          First.makeView(view: view.map { _ in first }, inputs: inputs).preferenceValues
        case let .second(second):
          Second.makeView(view: view.map { _ in second }, inputs: inputs).preferenceValues
        }
      },
      displayItems: inputs.graph.attribute("[Either] display items") {
        switch view.value.value {
        case let .first(first):
          First.makeView(view: view.map { _ in first }, inputs: inputs).displayItems
        case let .second(second):
          Second.makeView(view: view.map { _ in second }, inputs: inputs).displayItems
        }
      }
    )
  }
}
