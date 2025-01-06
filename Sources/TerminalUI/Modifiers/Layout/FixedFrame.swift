
extension View {

  public func frame(
    width: Int? = nil,
    height: Int? = nil
  ) -> some View {
    FixedFrame(content: self, width: width, height: height)
  }
}

private struct FixedFrame<Content: View>: Builtin, View {

  let content: Content
  let width: Int?
  let height: Int?

  func size(
    for proposal: ProposedSize,
    environment: EnvironmentValues
  ) -> Size {
    let proposedSize = ProposedSize(
      width: width ?? proposal.width,
      height: height ?? proposal.height)
    let size = content._size(for: proposedSize, environment: environment)
    return Size(width: width ?? size.width, height: height ?? size.height)
  }

  func render(
    in canvas: any Canvas,
    size: Size,
    environment: EnvironmentValues
  ) {
    let proposedSize = ProposedSize(width: size.width, height: size.height)
    let size = content._size(for: proposedSize, environment: environment)
    let x = (proposedSize.width - size.width) / 2
    let y = (proposedSize.height - size.height) / 2
    let canvas = canvas.translateBy(x: x, y: y)
    content._render(
      in: canvas,
      size: size,
      environment: environment)
  }
}
