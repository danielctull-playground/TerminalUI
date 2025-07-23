
extension View {

  public func frame(
    width: Int? = nil,
    height: Int? = nil,
    alignment: Alignment = .center
  ) -> some View {
    FixedFrame(width: width, height: height, alignment: alignment) { self }
  }
}

private struct FixedFrame {
  let width: Int?
  let height: Int?
  let alignment: Alignment
}

extension FixedFrame: Layout {

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) -> Size {
    var fallback: Size { proposal.replacingUnspecifiedDimensions() }
    let proposal = ProposedViewSize(
      width: width ?? fallback.width,
      height: height ?? fallback.height)
    let size = subviews[0].sizeThatFits(proposal)
    return Size(width: width ?? size.width, height: height ?? size.height)
  }

  func placeSubviews(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) {
    let parent = alignment.position(for: bounds.size)
    let size = subviews[0].sizeThatFits(proposal)
    let child = alignment.position(for: size)
    let position = Position(
      x: bounds.origin.x + parent.x - child.x,
      y: bounds.origin.y + parent.y - child.y)
    subviews[0].place(at: position, proposal: ProposedViewSize(size))
  }
}
