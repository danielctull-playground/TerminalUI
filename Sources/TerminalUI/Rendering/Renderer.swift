import AttributeGraph
import Foundation

package struct Renderer<Content: View, Canvas: TerminalUI.Canvas> {

  private let canvas: Canvas
  @Input private var environment: EnvironmentValues
  private let externalEnvironment: ExternalEnvironment
  private let outputs: ViewOutputs

  init(
    canvas: Canvas,
    environment externalEnvironment: ExternalEnvironment,
    content: Content
  ) {
    let graph = Graph()
    let screen = graph.attribute("screen") { Screen(content: content) }
    let environment = graph.input("environment", EnvironmentValues())

    let inputs = ViewInputs(
      graph: graph,
      canvas: canvas,
      dynamicProperties: DynamicProperties(
        graph: graph,
        environment: environment.projectedValue,
        state: graph.input("state", StateValues())
      )
    )

    self.canvas = canvas
    self.outputs = Screen.makeView(
      view: GraphValue(value: screen),
      inputs: inputs
    )
    self.externalEnvironment = externalEnvironment
    self._environment = environment
  }

  package func render() {

    externalEnvironment.update(&environment)

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
    environment: ExternalEnvironment,
    @ViewBuilder content: () -> Content
  ) {
    self.init(canvas: canvas, environment: environment, content: content())
  }
}
