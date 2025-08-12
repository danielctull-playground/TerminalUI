import AttributeGraph
import Foundation

@MainActor
struct Renderer<Content: View, Canvas: TerminalUI.Canvas> {

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

  func run() {

    let inputs = ViewInputs(
      graph: graph,
      canvas: canvas,
      node: $screen,
      environment: $environment)

    let output = Screen.makeView(inputs: inputs)

    func render() {
      environment.windowSize = .window
      _ = output.preferences // Trigger preferences
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

  init(
    canvas: Canvas,
    @ViewBuilder content: () -> Content
  ) {
    self.init(canvas: canvas, content: content())
  }
}
