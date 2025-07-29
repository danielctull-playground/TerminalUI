
public protocol View {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  @ViewBuilder
  var body: Body { get }
}

extension View {

  func makeView(inputs: ViewInputs<Self>) -> ViewOutputs{
    inputs.environment.install(on: self)
    if let builtin = self as? any Builtin {
      return builtin.makeView(inputs: inputs)
    } else {
      return body.makeView(inputs: inputs.body)
    }
  }
}
