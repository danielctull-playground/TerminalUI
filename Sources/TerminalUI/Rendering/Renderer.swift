import AttributeGraph
import Foundation

package struct Renderer<Content: View, Screen: TerminalUI.Screen> {

  private let graph: Graph
  private let screen: Screen
  private let environment: Attribute<EnvironmentValues>
  private let geometry: Attribute<ViewGeometry>
  private let outputs: ViewOutputs

  init(
    screen: Screen,
    content: Content
  ) {
    let graph = Graph()
    let content = graph.constant(FullScreen(content))

    var values = EnvironmentValues()
    values.focusManager = FocusManager(graph: graph)
    let environment = graph.external(of: EnvironmentValues.self)
    graph.setValue(of: environment, to: values)

    geometry = graph.map(environment) {
      ViewGeometry(frame: Rect(origin: .origin, size: $0.windowSize.size))
    }

    let inputs = ViewInputs(
      graph: graph,
      environment: environment,
      geometry: geometry
    )

    self.graph = graph
    self.screen = screen
    self.environment = environment
    self.outputs = FullScreen.makeView(
      view: content,
      inputs: inputs
    )
  }

  package func render(event: some Event) {

    var environmentValues = graph[environment]
    event.updateEnvironment(&environmentValues)
    graph.setValue(of: environment, to: environmentValues)

    graph.withUpdate {

      _ = graph[outputs.preferenceValues] // Trigger preference values
      
      let root = graph[outputs.layoutProxies].first!
      let frame = graph[geometry].frame
      if frame.size.width > 0, frame.size.height > 0 {
        root.place(in: frame)
      }

      let displayList = graph[outputs.displayList]

      screen.rasterize(displayList)
    }
  }
}

extension Renderer {

  package init(
    screen: Screen,
    @ViewBuilder content: () -> Content
  ) {
    self.init(screen: screen, content: content())
  }
}
