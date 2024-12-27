
extension View {

  public func frame(
    width: Horizontal? = nil,
    height: Vertical? = nil
  ) -> some View {
    FixedFrame(content: self, width: width, height: height)
  }
}

private struct FixedFrame<Content: View>: Builtin, View {

  let content: Content
  let width: Horizontal?
  let height: Vertical?

  func size(
    for proposal: ProposedSize,
    environment: EnvironmentValues
  ) -> Size? {
    let proposedSize = ProposedSize(
      width: width ?? proposal.width,
      height: height ?? proposal.height)
    let size = content._size(for: proposedSize, environment: environment)
    guard let size else { return nil }
    return Size(width: width ?? size.width, height: height ?? size.height)
  }

  func render(
    in canvas: any Canvas,
    size: Size,
    environment: EnvironmentValues
  ) {
    let proposedSize = ProposedSize(width: size.width, height: size.height)
    let size = content._size(for: proposedSize, environment: environment)
    guard let size else { return }
    let canvas = canvas.translateBy(
      x: Horizontal(proposedSize.width.distance(to: size.width) / 2),
      y: Vertical(proposedSize.height.distance(to: size.height) / 2))
    content._render(
      in: canvas,
      size: size,
      environment: environment)
  }
}
