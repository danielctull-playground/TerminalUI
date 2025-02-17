
public struct HStack {

  private let alignment: VerticalAlignment
  private let _spacing: Int?
  private var spacing: Int { _spacing ?? 0 }

  public init(
    alignment: VerticalAlignment = .center,
    spacing: Int? = nil
  ) {
    self.alignment = alignment
    self._spacing = spacing
  }
}

extension HStack: Layout {

  public func makeCache(subviews: Subviews) -> [Size] {
    subviews.map { _ in .zero }
  }

  public func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout [Size]
  ) -> Size {

    let flexibilities = subviews.map { subview in
      let min = ProposedViewSize(width: 0, height: proposal.height)
      let max = ProposedViewSize(width: .max, height: proposal.height)
      let smallest = subview.sizeThatFits(min)
      let largest = subview.sizeThatFits(max)
      return largest.width - smallest.width
    }

    let indexedSubviews = zip(flexibilities, zip(subviews.indices, subviews))
      .sorted(by: \.0)
      .map(\.1)

    let totalSpacing = spacing * (subviews.count - 1)
    var remainingSubviews = subviews.count
    var remainingWidth = proposal.replacingUnspecifiedDimensions().width - totalSpacing

    for (index, subview) in indexedSubviews {

      let proposal = ProposedViewSize(
        width: remainingWidth / remainingSubviews,
        height: proposal.height)

      let size = subview.sizeThatFits(proposal)

      cache[index] = size
      remainingSubviews -= 1
      remainingWidth -= size.width
    }

    let width = cache.map(\.width).reduce(0, +) + totalSpacing
    let height = cache.map(\.height).max() ?? 0
    return Size(width: width, height: height)
  }

  public func placeSubviews(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout [Size]
  ) {
    var offset = bounds.minX
    for (subview, size) in zip(subviews, cache) {
      let x = offset
      let y = bounds.minY + alignment.value(in: bounds.size) - alignment.value(in: size)
      subview.place(at: Position(x: x, y: y), proposal: ProposedViewSize(size))
      offset += size.width + spacing
    }
  }
}
