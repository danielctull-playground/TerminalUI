
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
    environment: EnvironmentValues
  ) -> Size {
    var fallback: Size { proposal.replacingUnspecifiedDimensions() }
    let proposal = ProposedViewSize(
      width: width ?? fallback.width,
      height: height ?? fallback.height)
    let size = content._size(for: proposal, environment: environment)
    return Size(width: width ?? size.width, height: height ?? size.height)
  }

  func render(
    in canvas: any Canvas,
    size: Size,
    environment: EnvironmentValues
  ) {
    let parent = alignment.position(for: size)
    let proposedSize = ProposedViewSize(width: size.width, height: size.height)
    let size = content._size(for: proposedSize, environment: environment)
    let child = alignment.position(for: size)
    let x = parent.x - child.x
    let y = parent.y - child.y
    let canvas = canvas.translateBy(x: x, y: y)
    content._render(
      in: canvas,
      size: size,
      environment: environment)
  }
}
