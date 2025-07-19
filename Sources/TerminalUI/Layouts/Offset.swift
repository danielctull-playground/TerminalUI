
extension View {

  public func offset(x: Int = 0, y: Int = 0) -> some View {
    Offset(x: x, y: y) { [AnyView(self)] }
  }

  public func offset(size: Size) -> some View {
    Offset(x: size.width, y: size.height) { [AnyView(self)] }
  }
}

private struct Offset {
  let x: Int
  let y: Int
}

extension Offset: Layout {

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) -> Size {
    subviews[0].sizeThatFits(proposal)
  }

  func placeSubviews(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) {
    subviews[0].place(
      at: Position(x: bounds.minX + x, y: bounds.minY + y),
      proposal: proposal)
  }
}
