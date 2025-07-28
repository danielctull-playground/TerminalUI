
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

  func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(displayItems: Content.makeView(inputs: inputs.content).displayItems.map { item in
      DisplayItem { proposal in
        item.size(for: proposal)
      } render: { bounds in
        item.render(in: Rect(
          x: bounds.minX + x,
          y: bounds.minY + y,
          width: bounds.size.width,
          height: bounds.size.height))
      }
    })
  }
}
