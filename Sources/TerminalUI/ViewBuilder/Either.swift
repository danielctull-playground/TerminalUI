import AttributeGraph

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
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.rule { graph in
        switch graph[view].value {
        case let .first(first):
          graph[First.makeView(view: graph.map(view) { _ in first }, inputs: inputs).preferenceValues]
        case let .second(second):
          graph[Second.makeView(view: graph.map(view) { _ in second }, inputs: inputs).preferenceValues]
        }
      },
      displayItems: inputs.graph.rule { graph in
        switch graph[view].value {
        case let .first(first):
          graph[First.makeView(view: graph.map(view) { _ in first }, inputs: inputs).displayItems]
        case let .second(second):
          graph[Second.makeView(view: graph.map(view) { _ in second }, inputs: inputs).displayItems]
        }
      }
    )
  }
}
