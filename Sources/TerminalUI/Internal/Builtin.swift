
protocol Builtin {
  func size(
    for proposal: ProposedViewSize,
    environment: EnvironmentValues
  ) -> Size

  func render(in bounds: Rect, canvas: any Canvas, environment: EnvironmentValues)
}

extension Builtin {
  public var body: Never {
    fatalError("Body should never be called.")
  }
}
