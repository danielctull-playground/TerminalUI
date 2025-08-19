
extension View {

  public func padding(_ insets: EdgeInsets) -> some View {
    Padding(insets: insets) { self }
  }

  public func padding(_ set: Edge.Set, _ value: Int) -> some View {
    padding(EdgeInsets(set: set, value: value))
  }

  public func padding(_ length: Int) -> some View {
    padding(.all, length)
  }
}

private struct Padding: LayoutModifier {

  let insets: EdgeInsets

  func sizeThatFits(
    proposal: ProposedViewSize,
    subview: Subview
  ) -> Size {

    let width = insets.leading + insets.trailing
    let height = insets.top + insets.bottom

    let proposal = ProposedViewSize(
      width: proposal.width.map { $0 - width },
      height: proposal.height.map { $0 - height })

    let size = subview.sizeThatFits(proposal)

    return Size(
      width: size.width + width,
      height: size.height + height)
  }

  func placeSubview(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subview: Subview
  ) {

    let origin = Position(
      x: bounds.origin.x + insets.leading,
      y: bounds.origin.y + insets.top)

    let proposal = ProposedViewSize(
      width: proposal.width.map { $0 - insets.leading - insets.trailing },
      height: proposal.height.map { $0 - insets.top - insets.bottom })

    subview.place(at: origin, proposal: proposal)
  }
}
