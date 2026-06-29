import AttributeGraph

public struct Either<First: View, Second: View>: PrimitiveView {

  fileprivate enum Value {
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

    let (_, first) = inputs.graph.subgraph {
      First.makeView(
        view: inputs.graph.map(view, \.value.first.unsafelyUnwrapped),
        inputs: inputs
      )
    }

    let (_, second) = inputs.graph.subgraph {
      Second.makeView(
        view: inputs.graph.map(view, \.value.second.unsafelyUnwrapped),
        inputs: inputs
      )
    }

    return ViewOutputs(
      preferenceValues: inputs.graph.rule { graph in
        switch graph[view].value {
        case .first: graph[first.preferenceValues]
        case .second: graph[second.preferenceValues]
        }
      },
      displayItems: inputs.graph.rule { graph in
        switch graph[view].value {
        case .first: graph[first.displayItems]
        case .second: graph[second.displayItems]
        }
      }
    )
  }
}

extension Either.Value {

  fileprivate var first: First? {
    switch self {
    case .first(let first): first
    case .second: nil
    }
  }

  fileprivate var second: Second? {
    switch self {
    case .first: nil
    case .second(let second): second
    }
  }
}
