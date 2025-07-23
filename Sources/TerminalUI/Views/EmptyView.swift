
public struct EmptyView: Builtin, View {

  public init() {}

  func displayItems(inputs: ViewInputs) -> [DisplayItem] {
    []
  }
}
