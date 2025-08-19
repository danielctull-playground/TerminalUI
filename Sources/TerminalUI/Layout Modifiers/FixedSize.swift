
extension View {

  public func fixedSize(
    horizontal: Bool = true,
    vertical: Bool = true
  ) -> some View {
    FixedSize(horizontal: horizontal, vertical: vertical) { self }
  }
}

private struct FixedSize: LayoutModifier {

  let horizontal: Bool
  let vertical: Bool

  func sizeThatFits(
    proposal: ProposedViewSize,
    subview: Subview
  ) -> Size {
    var proposal = proposal
    if horizontal { proposal.width = nil }
    if vertical { proposal.height = nil }
    return subview.sizeThatFits(proposal)
  }

  func placeSubview(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subview: Subview
  ) {
    subview.place(at: bounds.origin, proposal: proposal)
  }
}
