
protocol Builtin {
  func size(
    for proposal: ProposedViewSize,
    inputs: ViewInputs
  ) -> Size

  func render(in bounds: Rect, inputs: ViewInputs)
}

extension Builtin {
  public var body: Never {
    fatalError("Body should never be called.")
  }
}
