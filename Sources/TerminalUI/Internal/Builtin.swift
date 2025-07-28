
protocol Builtin {
  func makeView(inputs: ViewInputs) -> ViewOutputs
}

extension Builtin {
  public var body: some View {
    fatalError("Body should never be called.")
  }
}
