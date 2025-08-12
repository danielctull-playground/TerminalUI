import AttributeGraph

package protocol Canvas {
  func draw(_ pixel: Pixel, at position: Position)
}

extension Canvas {

  package func render(size: Size, content: () -> some View) {
    render(in: Rect(origin: .origin, size: size), content: content)
  }

  package func render(in bounds: Rect, content: () -> some View) {

    let graph = Graph()
    let view = CanvasView(bounds: bounds, content: content())
    let canvasView = graph.input("canvas view", view).projectedValue
    let environment = graph.input("environment", EnvironmentValues()).projectedValue

    let inputs = ViewInputs(
      graph: graph,
      canvas: self,
      dynamicProperties: DynamicProperties(environment: environment),
      node: canvasView)

    CanvasView.makeView(inputs: inputs)
      .displayItems
      .first!
      .render(in: bounds)
  }
}

private struct CanvasView<Content: View>: View {

  let bounds: Rect
  let content: Content

  var body: some View {
    VStack {
      content
    }
    .frame(width: bounds.size.width, height: bounds.size.height)
  }
}
