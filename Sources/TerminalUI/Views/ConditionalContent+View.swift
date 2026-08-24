import AttributeGraph

extension ConditionalContent: View where TrueContent: View, FalseContent: View {}

extension ConditionalContent: PrimitiveView where TrueContent: View, FalseContent: View {}

extension ConditionalContent: DynamicView where TrueContent: View, FalseContent: View {

  enum ID {
    case `true`
    case `false`
  }

  static func childInfo(
    graph: Graph,
    view: Attribute<Self>
  ) -> ID {
    switch graph[view].value {
    case .true: .true
    case .false: .false
    }
  }

  static func makeChildView(
    graph: Graph,
    id: ID,
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    switch id {
    case .true:
      TrueContent.makeView(
        view: graph.map(view) { $0.value.trueContent.unsafelyUnwrapped },
        inputs: inputs
      )
    case .false:
      FalseContent.makeView(
        view: graph.map(view) { $0.value.falseContent.unsafelyUnwrapped },
        inputs: inputs
      )
    }
  }
}

extension ConditionalContent.Value {

  fileprivate var trueContent: TrueContent? {
    switch self {
    case .true(let content): content
    case .false: nil
    }
  }

  fileprivate var falseContent: FalseContent? {
    switch self {
    case .true: nil
    case .false(let content): content
    }
  }
}
