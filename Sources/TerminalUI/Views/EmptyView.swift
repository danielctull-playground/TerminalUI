
public struct EmptyView: Builtin, View {

  public init() {}

  func makeView(inputs: ViewInputs) -> ViewOutputs {
    ViewOutputs(displayItems: [])
  }
}
