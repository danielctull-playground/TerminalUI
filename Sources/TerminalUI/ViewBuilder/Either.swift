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

    unowned let graph = inputs.graph

    var active: (isFirst: Bool, subgraph: Subgraph, outputs: ViewOutputs)?

    let resolved = graph.rule { graph in

      let wantsFirst = switch graph[view].value {
      case .first: true
      case .second: false
      }

      // Tear down if different
      if active?.isFirst != wantsFirst {

        if let old = active {
          graph.invalidate(old.subgraph)
        }

        let (subgraph, outputs) = graph.subgraph {
          if wantsFirst {
            First.makeView(
              view: graph.map(view, \.value.first.unsafelyUnwrapped),
              inputs: inputs
            )
          } else {
            Second.makeView(
              view: graph.map(view, \.value.second.unsafelyUnwrapped),
              inputs: inputs
            )
          }
        }

        active = (wantsFirst, subgraph, outputs)
      }

      return active!.outputs
    }

    return ViewOutputs(
      preferenceValues: graph.map(resolved) { graph[$0.preferenceValues] },
      displayItems: graph.map(resolved) { graph[$0.displayItems] }
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
