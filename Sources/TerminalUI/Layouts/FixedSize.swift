
extension View {

  public func fixedSize(
    horizontal: Bool = true,
    vertical: Bool = true
  ) -> some View {
    FixedSize(horizontal: horizontal, vertical: vertical) { [self] }
  }
}

private struct FixedSize {
  let horizontal: Bool
  let vertical: Bool
}

extension FixedSize: Layout {

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) -> Size {
    var proposal = proposal
    if horizontal { proposal.width = nil }
    if vertical { proposal.height = nil }
    return subviews[0].sizeThatFits(proposal)
  }

  func placeSubviews(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) {
    subviews[0].place(at: bounds.origin, proposal: proposal)
  }
}
