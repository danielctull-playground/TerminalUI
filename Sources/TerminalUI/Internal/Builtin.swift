
protocol Builtin: View {
  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs
}

extension Builtin {
  public var body: Never {
    fatalError("Body should never be called.")
  }
}

struct ViewInputs<Content: View> {
  let content: Content
  let canvas: Canvas
  let environment: EnvironmentValues
}

struct ViewOutputs {
  let size: (ProposedViewSize) -> Size
  let render: (Size) -> Void
}
