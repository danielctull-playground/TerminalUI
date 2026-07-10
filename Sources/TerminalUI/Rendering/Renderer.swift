import AttributeGraph
import Foundation

package struct Renderer<Content: View, Canvas: TerminalUI.Canvas> {

  private let graph: Graph
  private let canvas: Canvas
  private let environment: Attribute<EnvironmentValues>
  private let geometry: Attribute<ViewGeometry>
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

    geometry = graph.map(environment) {
      ViewGeometry(frame: Rect(origin: .origin, size: $0.windowSize))
    }

    let inputs = ViewInputs(
      graph: graph,
      environment: environment,
      geometry: geometry
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
      
      let root = graph[outputs.layoutComputers].first!
      let frame = graph[geometry].frame
      root.place(in: frame)
      let displayList: DisplayList
      if frame.size.width > 0, frame.size.height > 0 {
        displayList = root.render()
      } else {
        displayList = DisplayList(items: [])
      }

      canvas.rasterize(displayList)
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
