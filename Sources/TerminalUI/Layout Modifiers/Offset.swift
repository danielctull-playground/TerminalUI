
extension View {

  public func offset(x: Int = 0, y: Int = 0) -> some View {
    Offset(content: self, x: x, y: y)
  }

  public func offset(size: Size) -> some View {
    Offset(content: self, x: size.width, y: size.height)
  }
}

private struct Offset<Content: View>: View {

  let content: Content
  let x: Int
  let y: Int

  var body: some View {
    fatalError("Body should never be called.")
  }

  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[Offset] preference values") {
        Content.makeView(inputs: inputs.map(\.content)).preferenceValues
      },
      displayItems: inputs.graph.attribute("[Offset] display items") {
        Content
          .makeView(inputs: inputs.map(\.content))
          .displayItems
          .map { item in
            DisplayItem { proposal in
              item.size(for: proposal)
            } render: { bounds in
              item.render(in: Rect(
                x: bounds.minX + inputs.node.x,
                y: bounds.minY + inputs.node.y,
                width: bounds.size.width,
                height: bounds.size.height))
            }
          }
      }
    )
  }
}
