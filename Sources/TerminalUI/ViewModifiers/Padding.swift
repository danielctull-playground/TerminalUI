
extension View {

  public func padding(_ length: Int) -> some View {
    padding(.all(length))
  }

  public func padding(
    top: Vertical = 0,
    leading: Horizontal = 0,
    bottom: Vertical = 0,
    trailing: Horizontal = 0
  ) -> some View {
    padding(EdgeInsets(
      top: top,
      leading: leading,
      bottom: bottom,
      trailing: trailing
    ))
  }

  public func padding(_ edgeInsets: EdgeInsets) -> some View {
    Padding(content: self, edgeInsets: edgeInsets)
  }
}

private struct Padding<Content: View>: Builtin, View {

  let content: Content
  let edgeInsets: EdgeInsets

  func render(in canvas: any Canvas, size: Size, environment: EnvironmentValues) {
    content.render(
      in: canvas.inset(edgeInsets),
      size: size.inset(edgeInsets),
      environment: environment
    )
  }
}

extension Canvas {
  func inset(_ insets: EdgeInsets) -> Canvas {
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
  func offset(by edgeInsets: EdgeInsets) -> Position {
    Position(x: x + edgeInsets.leading, y: y + edgeInsets.top)
  }
}

extension Size {
  func inset(_ edgeInsets: EdgeInsets) -> Size {
    Size(
      width: width - edgeInsets.leading - edgeInsets.trailing,
      height: height - edgeInsets.top - edgeInsets.bottom
    )
  }
}

public struct EdgeInsets {
  let top: Vertical
  let leading: Horizontal
  let bottom: Vertical
  let trailing: Horizontal

  public init(
    top: Vertical,
    leading: Horizontal,
    bottom: Vertical,
    trailing: Horizontal
  ) {
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }
}

extension EdgeInsets {
  static func all(_ length: Int) -> EdgeInsets {
    EdgeInsets(
      top: Vertical(length),
      leading: Horizontal(length),
      bottom: Vertical(length),
      trailing: Horizontal(length)
    )
  }
}
