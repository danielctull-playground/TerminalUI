
extension View {

  public func padding(_ insets: EdgeInsets) -> some View {
    Padding(content: self, insets: insets)
  }

  public func padding<Value>(
    _ set: Edge.Set<Value>,
    _ value: Value
  ) -> some View {
    padding(set.insets(value))
  }

  public func padding(_ length: Int) -> some View {
    padding(.all, length)
  }
}

private struct Padding<Content: View>: Builtin, View {

  let content: Content
  let insets: EdgeInsets

  func size(
    for proposedSize: ProposedSize,
    environment: EnvironmentValues
  ) -> Size {
    Size(proposedSize)
  }

  func render(
    in canvas: any Canvas,
    size: Size,
    environment: EnvironmentValues
  ) {
    content._render(
      in: canvas.inset(insets),
      size: size.inset(insets),
      environment: environment
    )
  }
}

extension Canvas {
  fileprivate func inset(_ insets: EdgeInsets) -> Canvas {
    InsetCanvas(base: self, insets: insets)
  }
}

private struct InsetCanvas<Base: Canvas>: Canvas {
  let base: Base
  let insets: EdgeInsets

  func draw(_ pixel: Pixel, at position: Position) {
    base.draw(pixel, at: position.offset(by: insets))
  }
}

extension Position {
  fileprivate func offset(by insets: EdgeInsets) -> Position {
    Position(x: x + insets.leading, y: y + insets.top)
  }
}

extension Size {
  fileprivate func inset(_ insets: EdgeInsets) -> Size {
    Size(
      width: width - insets.leading - insets.trailing,
      height: height - insets.top - insets.bottom
    )
  }
}
