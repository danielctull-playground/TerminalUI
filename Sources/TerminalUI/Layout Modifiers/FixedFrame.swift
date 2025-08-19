
extension View {

  public func frame(
    width: Int? = nil,
    height: Int? = nil,
    alignment: Alignment = .center
  ) -> some View {
    FixedFrame(width: width, height: height, alignment: alignment) { self }
  }
}

private struct FixedFrame: LayoutModifier {

  let width: Int?
  let height: Int?
  let alignment: Alignment

  func sizeThatFits(
    proposal: ProposedViewSize,
    subview: Subview
  ) -> Size {

    if let width, let height {
      return Size(width: width, height: height)
    }

    let fallback = proposal.replacingUnspecifiedDimensions()

    let proposal = ProposedViewSize(
      width: width ?? fallback.width,
      height: height ?? fallback.height)

    let size = subview.sizeThatFits(proposal)

    return Size(
      width: width ?? size.width,
      height: height ?? size.height)
  }

  func placeSubview(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subview: Subview
  ) {
    let parent = alignment.position(for: bounds.size)
    let size = subview.sizeThatFits(ProposedViewSize(bounds.size))
    let child = alignment.position(for: size)
    let position = Position(
      x: bounds.origin.x + parent.x - child.x,
      y: bounds.origin.y + parent.y - child.y)
    subview.place(at: position, proposal: ProposedViewSize(size))
  }
}
