
extension View {

  public func padding(_ insets: EdgeInsets) -> some View {
    Padding(insets: insets) { [AnyView(self)] }
  }

  public func padding(_ set: Edge.Set, _ value: Int) -> some View {
    padding(EdgeInsets(set: set, value: value))
  }

  public func padding(_ length: Int) -> some View {
    padding(.all, length)
  }
}

private struct Padding {
  let insets: EdgeInsets
}

extension Padding: Layout {

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) -> Size {
    subviews[0]
      .sizeThatFits(proposal.inset(insets))
      .inset(-insets)
  }

  func placeSubviews(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) {
    let bounds = bounds.inset(insets)
    subviews[0].place(at: bounds.origin, proposal: ProposedViewSize(bounds.size))
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
