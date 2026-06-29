import AttributeGraph

extension Optional: View where Wrapped: View {}

extension Optional: PrimitiveView where Wrapped: View {

  public static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    unowned let graph = inputs.graph

    var active: (isSome: Bool, subgraph: Subgraph, outputs: ViewOutputs)?

    let resolved = graph.rule { graph in

      let wantsSome = switch graph[view] {
      case .none: false
      case .some: true
      }

      // Tear down if different
      if active?.isSome != wantsSome {

        if let old = active {
          graph.invalidate(old.subgraph)
        }

        let (subgraph, outputs) = graph.subgraph {
          if wantsSome {
            Wrapped.makeView(
              view: graph.map(view, \.unsafelyUnwrapped),
              inputs: inputs
            )
          } else {
            EmptyView.makeView(
              view: graph.constant(EmptyView()),
              inputs: inputs
            )
          }
        }

        active = (wantsSome, subgraph, outputs)
      }

      return active!.outputs
    }

    return ViewOutputs(
      preferenceValues: graph.map(resolved) { graph[$0.preferenceValues] },
      displayItems: graph.map(resolved) { graph[$0.displayItems] }
    )
  }
}
