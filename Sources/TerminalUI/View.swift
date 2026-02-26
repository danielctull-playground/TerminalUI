
public protocol View {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  @ViewBuilder
  var body: Body { get }

  static func makeView(view: GraphValue<Self>, inputs: ViewInputs) -> ViewOutputs
}

extension View {

  public static func makeView(
    view: GraphValue<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[\(Self.self)] preference values") {
        inputs.dynamicProperties.install(on: view.value)
        return Body.makeView(view: view.body, inputs: inputs).preferenceValues
      },
      displayItems: inputs.graph.attribute("[\(Self.self)] display items") {
        inputs.dynamicProperties.install(on: view.value)
        return Body.makeView(view: view.body, inputs: inputs).displayItems
      }
    )
  }
}
