
public struct AnyView {

  private let makeView: (ViewInputs<Self>) -> ViewOutputs

  public init<Content: View>(_ view: Content) {
    makeView = { inputs in
      let inputs = inputs.map { _ in view }
      return Content._makeView(inputs)
    }
  }
}

extension AnyView: BuiltinView {

  public static func _makeView(_ inputs: ViewInputs<AnyView>) -> ViewOutputs {
    inputs.node.makeView(inputs)
  }
}
