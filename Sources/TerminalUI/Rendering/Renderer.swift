import AttributeGraph
import Foundation

@MainActor
package struct Renderer<Content: View, Canvas: TerminalUI.Canvas> {

  private let graph: Graph
  private let canvas: Canvas
  @Attribute private var screen: Screen<Content>
  @Input private var environment: EnvironmentValues

  let windowChange = DispatchSource.makeSignalSource(signal: SIGWINCH, queue: .main)

  init(canvas: Canvas, content: Content) {
    graph = Graph()
    self.canvas = canvas
    _screen = graph.attribute("screen") { Screen(content: content) }
    _environment = graph.input("environment", EnvironmentValues())
  }

  package func run() {

    let inputs = ViewInputs(
      graph: graph,
      canvas: canvas,
      dynamicProperties: DynamicProperties(
        graph: graph,
        environment: $environment
      ),
      node: $screen)

    let output = Screen.makeView(inputs: inputs)

    func render() {
      environment.windowSize = .window
      _ = output.preferenceValues // Trigger preference values
      output
        .displayItems
        .first!
        .render(in: Rect(origin: .origin, size: environment.windowSize))
    }

    windowChange.setEventHandler {
      render()
    }
    windowChange.resume()
    render()
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
