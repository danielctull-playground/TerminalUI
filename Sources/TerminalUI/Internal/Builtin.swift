
protocol Builtin {
  func displayItems(inputs: ViewInputs) -> [DisplayItem]
}

extension Builtin {
  public var body: some View {
    fatalError("Body should never be called.")
  }
}
