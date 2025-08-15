
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
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[\(Self.self)] preference values") {
        inputs.dynamicProperties.install(on: inputs.node)
        return Body.makeView(inputs: inputs.mapNode(\.body)).preferenceValues
      },
      displayItems: inputs.graph.attribute("[\(Self.self)] display items") {
        inputs.dynamicProperties.install(on: inputs.node)
        return Body.makeView(inputs: inputs.mapNode(\.body)).displayItems
      }
    )
  }
}
