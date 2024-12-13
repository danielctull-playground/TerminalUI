
protocol Builtin {
  func render(in canvas: Canvas, size: Size, environment: EnvironmentValues)
}

extension Builtin {
  public var body: Never {
    fatalError("Body should never be called.")
  }
}
