
public struct ZStack {

  private let alignment: Alignment

  public init(alignment: Alignment = .center) {
    self.alignment = alignment
  }
}

extension ZStack: Layout {

  public func makeCache(subviews: Subviews) -> [Size] {
    subviews.map { _ in .zero }
  }

  public func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout [Size]
  ) -> Size {

    for (index, subview) in zip(subviews.indices, subviews) {
      cache[index] = subview.sizeThatFits(proposal)
    }

    let width = cache.map(\.width).max() ?? 0
    let height = cache.map(\.height).max() ?? 0
    return Size(width: width, height: height)
  }

  public func placeSubviews(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout [Size]
  ) {
    for (subview, size) in zip(subviews, cache) {

      let x = bounds.minX
        + alignment.horizontal.value(in: bounds.size)
        - alignment.horizontal.value(in: size)

      let y = bounds.minY
        + alignment.vertical.value(in: bounds.size)
        - alignment.vertical.value(in: size)

      subview.place(at: Position(x: x, y: y), proposal: ProposedViewSize(size))
    }
  }
}
