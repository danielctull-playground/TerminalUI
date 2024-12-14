
protocol Builtin {
  func render(in canvas: any Canvas, environment: EnvironmentValues)
}

extension Builtin {
  public var body: Never {
    fatalError("Body should never be called.")
  }
}
