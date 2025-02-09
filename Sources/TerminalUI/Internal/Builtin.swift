
protocol Builtin {

  func makeView(inputs: ViewInputs) -> ViewOutputs

  func render(in canvas: any Canvas, size: Size, inputs: ViewInputs)
}

extension Builtin {
  public var body: Never {
    fatalError("Body should never be called.")
  }
}
