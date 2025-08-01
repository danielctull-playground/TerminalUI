
extension View {

  public func offset(x: Int = 0, y: Int = 0) -> some View {
    Offset(content: self, x: x, y: y)
  }

  public func offset(size: Size) -> some View {
    Offset(content: self, x: size.width, y: size.height)
  }
}

private struct Offset<Content: View>: Builtin, View {

  let content: Content
  let x: Int
  let y: Int

  func displayItems(inputs: ViewInputs) -> [DisplayItem] {
    content.displayItems(inputs: inputs).map { item in
      DisplayItem { proposal in
        item.size(for: proposal)
      } render: { bounds in
        item.render(in: Rect(
          x: bounds.minX + x,
          y: bounds.minY + y,
          width: bounds.size.width,
          height: bounds.size.height))
      }
    }
  }
}
