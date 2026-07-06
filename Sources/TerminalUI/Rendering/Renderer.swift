import AttributeGraph
import Foundation

package struct Renderer<Content: View, Canvas: TerminalUI.Canvas> {

  private let graph: Graph
  private let canvas: Canvas
  private let environment: Attribute<EnvironmentValues>
  private let outputs: ViewOutputs

  init(
    canvas: Canvas,
    content: Content
  ) {
    let graph = Graph()
    let screen = graph.constant(Screen(content: content))

    var values = EnvironmentValues()
    values.focusManager = FocusManager(graph: graph)
    let environment = graph.external(of: EnvironmentValues.self)
    graph.setValue(of: environment, to: values)

    let inputs = ViewInputs(
      graph: graph,
      canvas: canvas,
      environment: environment
    )

    self.graph = graph
    self.canvas = canvas
    self.environment = environment
    self.outputs = Screen.makeView(
      view: screen,
      inputs: inputs
    )
  }

  package func render(event: some Event) {

    var environmentValues = graph[environment]
    event.updateEnvironment(&environmentValues)
    graph.setValue(of: environment, to: environmentValues)

    graph.withUpdate {

      _ = graph[outputs.preferenceValues] // Trigger preference values
      
      graph[outputs.displayItems]
        .first!
        .render(in: Rect(origin: .origin, size: graph[environment].windowSize))
    }
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
