
protocol Builtin {
  func size(
    for proposal: ProposedSize,
    environment: EnvironmentValues
  ) -> Size

  func render(in canvas: any Canvas, size: Size, environment: EnvironmentValues)
}

extension Builtin {
  public var body: Never {
    fatalError("Body should never be called.")
  }
}
