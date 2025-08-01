import AttributeGraph
import Dispatch

struct Renderer<Content: View, Canvas: TerminalUI.Canvas> {

  private let canvas: Canvas
  private let content: Content
  private let graph: Graph
  @Input private var environment: EnvironmentValues

  let windowChange = DispatchSource.makeSignalSource(signal: SIGWINCH, queue: .main)

  init(canvas: Canvas, content: Content) {
    self.canvas = canvas
    self.content = content
    graph = Graph()
    _environment = graph.input("environment", EnvironmentValues())
  }

  func run() -> Never {

    let inputs = ViewInputs(
      graph: graph,
      canvas: canvas,
      node: graph.attribute("root view") { Screen(content: self.content) },
      environment: $environment)

    let output = Screen.makeView(inputs: inputs)

    func render() {
      output
        .displayItems
        .first!
        .render(in: environment.windowBounds)
    }

    func updateWindow() {
      environment.windowBounds = Rect(origin: .origin, size: .window)
      render()
    }

    windowChange.setEventHandler(handler: updateWindow)
    windowChange.resume()
    updateWindow()

    dispatchMain()
  }
}
