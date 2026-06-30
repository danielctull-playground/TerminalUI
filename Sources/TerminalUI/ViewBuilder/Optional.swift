import AttributeGraph

extension Optional: View where Wrapped: View {}

extension Optional: PrimitiveView where Wrapped: View {}

extension Optional: DynamicView where Wrapped: View {

  enum ID {
    case some
    case none
  }

  static func childInfo(
    graph: Graph,
    view: Attribute<Self>
  ) -> ID {
    switch graph[view] {
    case .none: .none
    case .some: .some
    }
  }

  static func makeChildView(
    graph: Graph,
    id: ID,
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    switch id {
    case .some:
      Wrapped.makeView(
        view: graph.map(view, \.unsafelyUnwrapped),
        inputs: inputs
      )
    case .none:
      EmptyView.makeView(
        view: graph.constant(EmptyView()),
        inputs: inputs
      )
    }
  }
}
