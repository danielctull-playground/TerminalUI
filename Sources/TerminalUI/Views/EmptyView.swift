
public struct EmptyView: Builtin, View {

  public init() {}

  func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(displayItems: [])
  }
}
