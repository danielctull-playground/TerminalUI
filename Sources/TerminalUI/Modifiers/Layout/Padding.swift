
extension View {

  public func padding(_ insets: EdgeInsets) -> some View {
    Padding(content: self, insets: insets)
  }

  public func padding<Value>(
    _ set: Edge.Set<Value>,
    _ value: Value
  ) -> some View {
    padding(set.insets(value))
  }

  public func padding(_ length: Int) -> some View {
    padding(.all, length)
  }
}

private struct Padding<Content: View>: Builtin, View {

  let content: Content
  let insets: EdgeInsets

  func size(
    for proposedSize: ProposedSize,
    environment: EnvironmentValues
  ) -> Size {
    content
      ._size(for: proposedSize.inset(insets), environment: environment)
      .inset(-insets)
  }

  func render(
    in canvas: any Canvas,
    size: Size,
    environment: EnvironmentValues
  ) {
    content._render(
      in: canvas.translateBy(x: insets.leading, y: insets.top),
      size: size.inset(insets),
      environment: environment
    )
  }
}

extension ProposedSize {
  fileprivate func inset(_ insets: EdgeInsets) -> ProposedSize {
    ProposedSize(
      width: width - insets.leading - insets.trailing,
      height: height - insets.top - insets.bottom
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
