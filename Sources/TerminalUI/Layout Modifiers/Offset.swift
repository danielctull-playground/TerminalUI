
extension View {

  public func offset(x: Int = 0, y: Int = 0) -> some View {
    Offset(x: x, y: y) { self }
  }

  public func offset(size: Size) -> some View {
    Offset(x: size.width, y: size.height) { self }
  }
}

private struct Offset: LayoutModifier {

  let x: Int
  let y: Int

  func sizeThatFits(
    proposal: ProposedViewSize,
    subview: Subview
  ) -> Size {
    subview.sizeThatFits(proposal)
  }

  func placeSubview(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subview: Subview
  ) {
    subview.place(
      at: Position(x: bounds.minX + x, y: bounds.minY + y),
      proposal: proposal)
  }
}
