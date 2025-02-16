
public struct VStack {

  private let alignment: HorizontalAlignment
  private let _spacing: Int?
  private var spacing: Int { _spacing ?? 0 }

  public init(
    alignment: HorizontalAlignment = .center,
    spacing: Int? = nil
  ) {
    self.alignment = alignment
    self._spacing = spacing
  }
}

extension VStack: Layout {

  public func makeCache(subviews: Subviews) -> [Size] {
    subviews.map { _ in .zero }
  }

  public func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout [Size]
  ) -> Size {

    let flexibilities = subviews.map { subview in
      let min = ProposedViewSize(width: proposal.width, height: 0)
      let max = ProposedViewSize(width: proposal.width, height: .max)
      let smallest = subview.sizeThatFits(min)
      let largest = subview.sizeThatFits(max)
      return largest.height - smallest.height
    }

    let indexedSubviews = zip(flexibilities, zip(subviews.indices, subviews))
      .sorted(by: \.0)
      .map(\.1)

    let totalSpacing = spacing * (subviews.count - 1)
    var remainingSubviews = subviews.count
    var remainingHeight = proposal.replacingUnspecifiedDimensions().height - totalSpacing

    for (index, subview) in indexedSubviews {

      let proposal = ProposedViewSize(
        width: proposal.width,
        height: remainingHeight / remainingSubviews)

      let size = subview.sizeThatFits(proposal)

      cache[index] = size
      remainingSubviews -= 1
      remainingHeight -= size.height
    }

    let width = cache.map(\.width).max() ?? 0
    let height = cache.map(\.height).reduce(0, +) + totalSpacing
    return Size(width: width, height: height)
  }

  public func placeSubviews(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout [Size]
  ) {
    var offset = bounds.minY
    for (subview, size) in zip(subviews, cache) {
      let x = bounds.minX + alignment.value(in: bounds.size) - alignment.value(in: size)
      let y = offset
      subview.place(at: Position(x: x, y: y), proposal: ProposedViewSize(size))
      offset += size.height + spacing
    }
  }
}
