import AttributeGraph

extension View {

  public func hidden(_ isActive: Bool = true) -> some View {
    Hidden(hidden: isActive) { self }
  }
}

private struct Hidden: LayoutModifier {

  let hidden: Bool

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
    if !hidden {
      subview.place(at: bounds.origin, proposal: proposal)
    }
  }
}
