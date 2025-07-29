
protocol Builtin {
  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs
}

extension Builtin {
  public var body: some View {
    fatalError("Body should never be called.")
  }
}
