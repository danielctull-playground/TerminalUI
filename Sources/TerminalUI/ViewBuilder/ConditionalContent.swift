import AttributeGraph

public struct ConditionalContent<TrueContent: View, FalseContent: View> {

  fileprivate enum Value {
    case `true`(TrueContent)
    case `false`(FalseContent)
  }

  private let value: Value

  init(_ content: TrueContent) {
    value = .true(content)
  }

  init(_ content: FalseContent) {
    value = .false(content)
  }
}

extension ConditionalContent: DynamicView {

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
        view: graph.map(view, \.value.trueContent.unsafelyUnwrapped),
        inputs: inputs
      )
    case .false:
      FalseContent.makeView(
        view: graph.map(view, \.value.falseContent.unsafelyUnwrapped),
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
