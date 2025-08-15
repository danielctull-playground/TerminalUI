
extension View {

  public func padding(_ insets: EdgeInsets) -> some View {
    Padding(content: self, insets: insets)
  }

  public func padding(_ set: Edge.Set, _ value: Int) -> some View {
    padding(EdgeInsets(set: set, value: value))
  }

  public func padding(_ length: Int) -> some View {
    padding(.all, length)
  }
}

private struct Padding<Content: View>: View {

  let content: Content
  let insets: EdgeInsets

  var body: some View {
    fatalError("Body should never be called.")
  }

  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[Padding] preference values") {
        Content.makeView(inputs: inputs.mapNode(\.content)).preferenceValues
      },
      displayItems: inputs.graph.attribute("[Padding] display items") {
        Content
          .makeView(inputs: inputs.mapNode(\.content))
          .displayItems
          .map { item in
            DisplayItem { proposal in
              item
                .size(for: proposal.inset(inputs.node.insets))
                .inset(-inputs.node.insets)
            } render: { bounds in
              item.render(in: bounds.inset(inputs.node.insets))
            }
          }
      }
    )
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
