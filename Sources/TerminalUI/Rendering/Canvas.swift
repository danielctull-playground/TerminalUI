
package protocol Canvas {
  func draw(_ pixel: Pixel, at position: Position)
}

extension Canvas {

  package func render(size: Size, content: () -> some View) {
    render(in: Rect(origin: .origin, size: size), content: content)
  }

  package func render(in bounds: Rect, content: () -> some View) {
    VStack {
      content()
    }
    .frame(width: bounds.size.width, height: bounds.size.height)
    .makeView(inputs: ViewInputs(canvas: self))
    .displayItems
    .first!
    .render(in: bounds)
  }
}
