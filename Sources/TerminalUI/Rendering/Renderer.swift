import AttributeGraph
import Foundation

package struct Renderer<Content: View, Canvas: TerminalUI.Canvas> {

  private let canvas: Canvas
  @External private var environment: EnvironmentValues
  private let outputs: ViewOutputs

  init(
    canvas: Canvas,
    content: Content
  ) {
    let graph = Graph()
    let screen = graph.attribute("screen") { Screen(content: content) }
    let environment = graph.external("environment", EnvironmentValues())

    let inputs = ViewInputs(
      graph: graph,
      canvas: canvas,
      dynamicProperties: DynamicProperties(
        graph: graph,
        environment: environment.projectedValue,
        state: graph.external("state", StateValues())
      )
    )

    self.canvas = canvas
    self.outputs = Screen.makeView(
      view: GraphValue(value: screen),
      inputs: inputs
    )
    self._environment = environment
  }

  package func render(event: some Event) {

    event.updateEnvironment(&environment)

    _ = outputs.preferenceValues // Trigger preference values

    outputs
      .displayItems
      .first!
      .render(in: Rect(origin: .origin, size: environment.windowSize))
  }
}


extension Renderer {

  package init(
    canvas: Canvas,
    @ViewBuilder content: () -> Content
  ) {
    self.init(canvas: canvas, content: content())
  }
}
