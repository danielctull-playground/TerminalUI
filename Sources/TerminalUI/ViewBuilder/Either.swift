import AttributeGraph

public struct Either<First: View, Second: View> {

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
}

extension Either: DynamicView {

  enum ID {
    case first
    case second
  }

  static func childInfo(
    graph: Graph,
    view: Attribute<Self>
  ) -> ID {
    switch graph[view].value {
    case .first: .first
    case .second: .second
    }
  }

  static func makeChildView(
    graph: Graph,
    id: ID,
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    switch id {
    case .first:
      First.makeView(
        view: graph.map(view) { $0.value.first.unsafelyUnwrapped },
        inputs: inputs
      )
    case .second:
      Second.makeView(
        view: graph.map(view) { $0.value.second.unsafelyUnwrapped },
        inputs: inputs
      )
    }
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
