
public protocol View {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  @ViewBuilder
  var body: Body { get }

  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs
}

extension View {

  public static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    inputs.environment.install(on: self)
    return Body.makeView(inputs: inputs.body)
  }
}
