
extension View {

  public func padding(_ insets: EdgeInsets) -> some View {
    Padding(content: self, insets: insets)
  }

  public func padding(_ set: Edge.Set, _ value: Int) -> some View {
    padding(EdgeInsets(set: set, value: value))
  }

  public func padding(_ length: Int) -> some View {
    padding(.all, length)
  }
}

private struct Padding<Content: View>: Builtin, View {

  let content: Content
  let insets: EdgeInsets

  func size(
    for proposal: ProposedViewSize,
    inputs: ViewInputs
  ) -> Size {
    content
      ._size(for: proposal.inset(insets), inputs: inputs)
      .inset(-insets)
  }

  func render(
    in canvas: any Canvas,
    bounds: Rect,
    inputs: ViewInputs
  ) {
    content._render(
      in: canvas,
      bounds: bounds.inset(insets),
      inputs: inputs
    )
  }
}

extension Rect {

  fileprivate func inset(_ insets: EdgeInsets) -> Rect {
    Rect(
      x: origin.x + insets.leading,
      y: origin.y + insets.top,
      width: size.width - insets.leading - insets.trailing,
      height: size.height - insets.top - insets.bottom)
  }

}

extension ProposedViewSize {
  fileprivate func inset(_ insets: EdgeInsets) -> ProposedViewSize {
    ProposedViewSize(
      width: width.map { $0 - insets.leading - insets.trailing },
      height: height.map { $0 - insets.top - insets.bottom }
    )
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

extension EdgeInsets {
  fileprivate static prefix func - (insets: EdgeInsets) -> EdgeInsets {
    EdgeInsets(
      top: -insets.top,
      leading: -insets.leading,
      bottom: -insets.bottom,
      trailing: -insets.trailing
    )
  }
}
