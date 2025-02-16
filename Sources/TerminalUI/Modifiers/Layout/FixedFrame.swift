
extension View {

  public func frame(
    width: Int? = nil,
    height: Int? = nil,
    alignment: Alignment = .center
  ) -> some View {
    FixedFrame(
      content: self,
      width: width,
      height: height,
      alignment: alignment)
  }
}

private struct FixedFrame<Content: View>: Builtin, View {

  let content: Content
  let width: Int?
  let height: Int?
  let alignment: Alignment

  func size(
    for proposal: ProposedViewSize,
    inputs: ViewInputs
  ) -> Size {
    var fallback: Size { proposal.replacingUnspecifiedDimensions() }
    let proposal = ProposedViewSize(
      width: width ?? fallback.width,
      height: height ?? fallback.height)
    let size = content._size(for: proposal, inputs: inputs)
    return Size(width: width ?? size.width, height: height ?? size.height)
  }

  func render(in bounds: Rect, inputs: ViewInputs) {
    let parent = alignment.position(for: bounds.size)
    let proposedSize = ProposedViewSize(bounds.size)
    let size = content._size(for: proposedSize, inputs: inputs)
    let child = alignment.position(for: size)
    let bounds = Rect(
      x: bounds.origin.x + parent.x - child.x,
      y: bounds.origin.y + parent.y - child.y,
      width: size.width,
      height: size.height)
    content._render(in: bounds, inputs: inputs)
  }
}
