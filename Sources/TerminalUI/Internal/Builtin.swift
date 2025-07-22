
protocol Builtin {
  func displayItems(inputs: ViewInputs) -> [DisplayItem]
}

extension Builtin {
  public var body: Never {
    fatalError("Body should never be called.")
  }
}
